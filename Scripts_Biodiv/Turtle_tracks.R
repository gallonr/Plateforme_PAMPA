#-*- coding: latin-1 -*-
# Time-stamp: <2018-12-12 16:53:51 yreecht>

## Plateforme PAMPA de calcul d'indicateurs de ressources & biodiversit�
##   Copyright (C) 2008-2018 Ifremer - Tous droits r�serv�s.
##
##   Ce programme est un logiciel libre ; vous pouvez le redistribuer ou le
##   modifier suivant les termes de la "GNU General Public License" telle que
##   publi�e par la Free Software Foundation : soit la version 2 de cette
##   licence, soit (� votre gr�) toute version ult�rieure.
##
##   Ce programme est distribu� dans l'espoir qu'il vous sera utile, mais SANS
##   AUCUNE GARANTIE : sans m�me la garantie implicite de COMMERCIALISABILIT�
##   ni d'AD�QUATION � UN OBJECTIF PARTICULIER. Consultez la Licence G�n�rale
##   Publique GNU pour plus de d�tails.
##
##   Vous devriez avoir re�u une copie de la Licence G�n�rale Publique GNU avec
##   ce programme ; si ce n'est pas le cas, consultez :
##   <http://www.gnu.org/licenses/>.

### File: Turtle_tracks.R
### Created: <2013-01-17 17:35:11 yves>
###
### Author: Yves Reecht
###
####################################################################################################
### Description: Scripts sp�cifiques pour le chargement et les calculs de m�triques relatives
###              aux traces de tortues (protocole Cara�bes ; type d'observation TRATO).
###
####################################################################################################

########################################################################################################################
obsFormatting.TRATO.f <- function(obs)
{
    ## Purpose: Mise en forme et nettoyage du fichier d'observations pour les
    ##          donn�es d'observation de types TRATO
    ## ----------------------------------------------------------------------
    ## Arguments: obs : table de donn�es d'observations.
    ## ----------------------------------------------------------------------
    ## Author: Yves Reecht, Date: 17 janv. 2013, 17:40

    ## Renommage des colonnes "number" et "min.distance" en "tracks.number" et "ponte" :
    colnames(obs)[match(c("number", "min.distance"), colnames(obs))] <- c("tracks.number", "ponte")

    ponte <- gsub("[[:blank:]]*", "", tolower(obs[ , "ponte"]))

    ponte[ponte == "nl"] <- "NL"
    ponte[ponte == ""] <- NA

    ## Recherche des donn�es incorrectes => NAs :
    if (sum(tmp <- ! (is.na(ponte) | is.element(ponte,
                                                c(paste0(rep(c(tolower(mltext("KW.yes")),
                                                               tolower(mltext("KW.no"))), each = 2),
                                                         c("", "?")),
                                                  "NL"))))) # [ml?]
    {
        ## Chang�es en NAs :
        ponte[tmp] <- NA

        ## Message au pluriel ?
        pl <- sum(tmp) > 1

        ## Message d'avertissement :
        infoLoading.f(msg=paste(ifelse(pl,
                                       mltext("obsFormatting.TRATO.info.1p"),
                                       mltext("obsFormatting.TRATO.info.1s")),
                                sum(tmp),
                                ifelse(pl,
                                       mltext("obsFormatting.TRATO.info.2p"),
                                       mltext("obsFormatting.TRATO.info.2s")),
                                ifelse(pl,
                                       mltext("obsFormatting.TRATO.info.3p"),
                                       mltext("obsFormatting.TRATO.info.3s")),
                                sep=""),
                      icon="warning")
    }else{}

    ## Sauvegarde dans obs :
    obs[ , "ponte"] <- factor(ponte)

    return(obs)
}

########################################################################################################################
calc.nestingSuccess.f <- function(obs,
                                  Data,
                                  factors=c("observation.unit", "species.code", "size.class"),
                                  nbName="number")
{
    ## Purpose: Calcul du pourcentage de r�ussite de ponte.
    ## ----------------------------------------------------------------------
    ## Arguments: obs : table des observations (data.frame).
    ##            Data : la table de m�trique (temporaire).
    ##            factors : les facteurs d'agr�gation.
    ##            nbName : nom de la colonne nombre.
    ##
    ## Output: vecteur des r�ussites de pontes (%).
    ## ----------------------------------------------------------------------
    ## Author: Yves Reecht, Date: 18 janv. 2013, 15:57

    ## Nombre de pontes (s�res + suppos�es) :
    pontes <- as.vector(tapply(subset(obs, grepl(paste0("^", mltext("KW.yes"), "\\??$"),
                                                 obs$ponte))[ , "number"],
                               as.list(subset(obs, grepl(paste0("^", mltext("KW.yes"), "\\??$"),
                                                         obs$ponte))[ , factors]),
                               FUN = function(x)
                               {
                                   ifelse(all(is.na(x)),
                                          as.numeric(NA),
                                   ifelse(all(is.element(na.omit(x), "NL")), # [ml?]
                                          0,
                                          sum(x, na.rm=TRUE)))
                               }))


    ## Correction de NAs � la place de 0 dans pontes lorsque aucune traces observ�es mais nombre valide (0) :
    pontes[is.na(pontes) & ! is.na(Data[ , nbName])] <- 0

    ## Nombre de traces lisibles :
    traces.lisibles <- as.vector(tapply(subset(obs,
                                               grepl(paste0("^(", mltext("KW.yes"), "|",
                                                            mltext("KW.no"), ")\\??$"), # "^(yes|no)\\??$"
                                                     obs$ponte))[ , "number"],
                                        as.list(subset(obs,
                                                       grepl(paste0("^(", mltext("KW.yes"), "|",
                                                                    mltext("KW.no"), ")\\??$"),
                                                             obs$ponte))[ , factors]),
                                        FUN = function(x)
                                        {
                                            ifelse(all(is.na(x)),
                                                   as.numeric(NA),
                                            ifelse(all(is.element(na.omit(x), "NL")),
                                                   0,
                                                   sum(x, na.rm=TRUE)))
                                        }))

    ## Correction de NAs � la place de 0 dans traces lisibles lorsque aucune traces observ�es mais nombre valide (0) :
    traces.lisibles[is.na(traces.lisibles) & ! is.na(Data[ , nbName])] <- 0

    return(data.frame("spawnings"=pontes, "readable.tracks"=traces.lisibles,
                      "spawning.success"=100 * pontes / traces.lisibles))
}


########################################################################################################################
calc.tables.TurtleTracks.f <- function(obs, unitobs, dataEnv, factors)
{
    ## Purpose: Calcul de m�triques � partir de traces de tortues.
    ## ----------------------------------------------------------------------
    ## Arguments: obs : table des observations (data.frame).
    ##            unitobs : table des unit�s d'observation (data.frame).
    ##            dataEnv : environnement des donn�es.
    ##            factors : les facteurs d'agr�gation.
    ## ----------------------------------------------------------------------
    ## Author: Yves Reecht, Date: 17 janv. 2013, 19:29

    ## Calcul des nombres par cl / esp�ces / unitobs :
    nbr <- calcNumber.default.f(obs, factors=factors, nbName="tracks.number")

    ## Cr�ation de la data.frame de r�sultats (avec nombres, unitobs, ):
    res <- calc.numbers.f(nbr, nbName="tracks.number")

    ## Calcul du succ�s de ponte (%) :
    res <- cbind(res, calc.nestingSuccess.f(obs=obs, Data=res, factors=factors, nbName="tracks.number"))

    ## Tailles moyennes :
    res[ , "mean.length"] <- calc.meanSize.f(obs, factors=factors, nbName="tracks.number")

    ## Poids :
    res[ , "weight"] <- calc.weight.f(obs=obs, Data=res, factors=factors, nbName="tracks.number")

    ## Poids moyen par individu :
    res[ , "mean.weight"] <- calc.meanWeight.f(Data=res, nbName="tracks.number")

    ## Pr�sence/absence :
    res[ , "pres.abs"] <- calc.presAbs.f(Data=res, nbName="tracks.number")

    return(res)
}






### Local Variables:
### ispell-local-dictionary: "english"
### fill-column: 120
### End:
