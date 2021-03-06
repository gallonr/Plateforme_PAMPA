#-*- coding: latin-1 -*-
# Time-stamp: <2018-12-12 16:53:52 yreecht>

## Plateforme PAMPA de calcul d'indicateurs de ressources & biodiversit�
##   Copyright (C) 2008-2013 Ifremer - Tous droits r�serv�s.
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

### File: Linear_models_generic_unitobs.R
### Created: <2012-01-11 19:27:55 yreecht>
###
### Author: Yves Reecht
###
####################################################################################################
### Description:
###
### Mod�les lin�aires pour les donn�es agr�g�es par unitobs (toutes esp�ces, �ventuellement
### s�lectionn�es selon un crit�re du r�f�rentiel).
####################################################################################################


########################################################################################################################
modeleLineaireWP2.unitobs.f <- function(metrique, factAna, factAnaSel, listFact, listFactSel, tableMetrique, dataEnv,
                                        baseEnv=.GlobalEnv)
{
    ## Purpose: Gestions des diff�rentes �tapes des mod�les lin�aires.
    ## ----------------------------------------------------------------------
    ## Arguments: metrique : la m�trique choisie.
    ##            factAna : le facteur de s�paration des graphiques.
    ##            factAnaSel : la s�lection de modalit�s pour ce dernier
    ##            listFact : liste du (des) facteur(s) de regroupement
    ##            listFactSel : liste des modalit�s s�lectionn�es pour ce(s)
    ##                          dernier(s)
    ##            tableMetrique : nom de la table de m�triques.
    ##            dataEnv : environnement de stockage des donn�es.
    ##            baseEnv : environnement de l'interface.
    ## ----------------------------------------------------------------------
    ## Author: Yves Reecht, Date: 18 ao�t 2010, 15:59

    ## Nettoyage des facteurs (l'interface de s�lection produit des valeurs vides) :
    listFactSel <- listFactSel[unlist(listFact) != ""]
    ## listFactSel <- listFactSel[length(listFactSel):1]

    listFact <- listFact[unlist(listFact) != ""]
    ## listFact <- listFact[length(listFact):1]

    ## Concat�nation
    facteurs <- c(factAna, unlist(listFact)) # Concat�nation des facteurs

    selections <- c(list(factAnaSel), listFactSel) # Concat�nation des leurs listes de modalit�s s�lectionn�es

    ## Donn�es pour la s�rie d'analyses :
    if (tableMetrique == "unit")
    {
        ## Pour les indices de biodiversit�, il faut travailler sur les nombres... :
        tmpData <- subsetToutesTables.f(metrique=getOption("P.nbName"), facteurs=facteurs,
                                        selections=selections, dataEnv=dataEnv, tableMetrique="unitSp",
                                        exclude = NULL, add=c("observation.unit", "species.code"))
    }else{
        ## ...sinon sur la m�trique choisie :
        tmpData <- subsetToutesTables.f(metrique=metrique, facteurs=facteurs, selections=selections,
                                        dataEnv=dataEnv, tableMetrique=tableMetrique, exclude = NULL,
                                        add=c("observation.unit", "species.code"))
    }

    ## Identification des diff�rents lots d'analyses � faire:
    if (factAna == "")                # Pas de facteur de s�paration des graphiques.
    {
        iFactGraphSel <- ""
    }else{
        if (is.na(factAnaSel[1]))            # Toutes les modalit�s.
        {
            iFactGraphSel <- unique(as.character(sort(tmpData[ , factAna])))
        }else{                              # Modalit�s s�lectionn�es (et pr�sentes parmi les donn�es retenues).
            iFactGraphSel <- factAnaSel[is.element(factAnaSel, tmpData[ , factAna])]
        }
    }

    ## Formules pour diff�rents mod�les (avec ou sans transformation log) :
    exprML <- eval(parse(text=paste(metrique, "~", paste(listFact, collapse=" * "))))
    logExprML <- eval(parse(text=paste("log(", metrique, ") ~", paste(listFact, collapse=" * "))))

    ## Agr�gation des observations / unit� d'observation :
    if (tableMetrique == "unitSpSz" && factAna != "size.class")
    {
        tmpData <- na.omit(agregationTableParCritere.f(Data=tmpData,
                                                       metrique=metrique,
                                                       facteurs=c("observation.unit", "size.class"),
                                                       dataEnv=dataEnv,
                                                       listFact=listFact))
    }else{
        if (tableMetrique == "unit")
        {
            ## Calcul des indices de biodiversit� sur s�lection d'esp�ces :
            tmp <- do.call(rbind,
                           lapply(getOption("P.MPA"),
                                  function(MPA)
                              {
                                  calcBiodiv.f(Data=tmpData,
                                               refesp=get("refesp", envir=dataEnv),
                                               MPA=MPA,
                                               unitobs = "observation.unit", code.especes = "species.code",
                                               nombres = getOption("P.nbName"),
                                               indices=metrique,
                                               dataEnv=dataEnv)
                              }))

            ## On rajoute les anciennes colonnes :
            tmpData <- cbind(tmp[ , colnames(tmp) != getOption("P.nbName")], # Colonne "nombre" d�sormais inutile.
                             tmpData[match(tmp$observation.unit, tmpData$observation.unit),
                                     !is.element(colnames(tmpData),
                                                 c(colnames(tmp), getOption("P.nbName"), "species.code")), drop=FALSE])

            ## On garde le strict minimum :
            tmpData <- tmpData[ , is.element(colnames(tmpData), c(metrique, facteurs))]
        }else{
            tmpData <- na.omit(agregationTableParCritere.f(Data=tmpData,
                                                           metrique=metrique,
                                                           facteurs=c("observation.unit"),
                                                           dataEnv=dataEnv,
                                                           listFact=listFact))
        }
    }

    ## Sauvegarde temporaire des donn�es utilis�es pour les analyses (attention : �cras�e � chaque nouvelle s�rie de
    ## graphiques) :
    DataBackup <<- list(tmpData)


    ## Suppression des 'levels' non utilis�s :
    tmpData <- dropLevels.f(tmpData)

    ## Aide au choix du type d'analyse :
    if (metrique == "pres.abs")
    {
        loiChoisie <- "BI"
    }else{
        loiChoisie <- choixDistri.f(metrique=metrique, Data=tmpData[ , metrique, drop=FALSE])
    }

    if (!is.null(loiChoisie))
    {
        message(mltext("modeleLineaireWP2.esp.dist"), " = ", loiChoisie)

        if (is.element(loiChoisie, c("LOGNO")))
        {
            Log <- TRUE
            formule <- logExprML
        }else{
            Log <- FALSE
            formule <- exprML
        }

        res <- calcLM.f(loiChoisie=loiChoisie, formule=formule, metrique=metrique, Data=tmpData)

        ## �criture des r�sultats format�s dans un fichier :
        tryCatch(sortiesLM.f(objLM=res, formule=formule, metrique=metrique,
                             factAna=factAna, modSel=iFactGraphSel,
                             listFact=listFact, listFactSel=listFactSel,
                             Data=tmpData, dataEnv=dataEnv, Log=Log,
                             type=ifelse(tableMetrique == "unitSpSz" && factAna != "size.class",
                                         "CL_unitobs",
                                         "unitobs"),
                             baseEnv=baseEnv),
                 error=errorLog.f)

        resid.out <- boxplot(residuals(res), plot=FALSE)$out

        if (length(resid.out))
        {
            suppr <- supprimeObs.f(residus=resid.out)

            if(!is.null(suppr))
            {
                if (!is.numeric(suppr)) # conversion en num�ros de lignes lorsque ce sont des noms :
                {
                    suppr <- which(is.element(row.names(tmpData), suppr))
                }else{}

                tmpData <- tmpData[ - suppr, ]
                res.red <- calcLM.f(loiChoisie=loiChoisie, formule=formule, metrique=metrique, Data=tmpData)

                resLM.red <<- res.red

                tryCatch(sortiesLM.f(objLM=res.red, formule=formule, metrique=metrique,
                                     factAna=factAna, modSel=iFactGraphSel,
                                     listFact=listFact, listFactSel=listFactSel,
                                     Data=tmpData, Log=Log, sufixe="(red)",
                                     type=ifelse(tableMetrique == "unitSpSz" && factAna != "size.class",
                                                 "CL_unitobs",
                                                 "unitobs"),
                                     dataEnv=dataEnv, baseEnv=baseEnv),
                         error=errorLog.f)
            }else{}

        }else{}

    }else{
        message("Annul� !")
    }
}






### Local Variables:
### ispell-local-dictionary: "english"
### fill-column: 120
### End:
