#-*- coding: latin-1 -*-
# Time-stamp: <2018-12-12 17:55:55 yreecht>

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

### File: Calculate_metrics_tables_LIT.R
### Created: <2012-01-09 13:32:21 yreecht>
###
### Author: Yves Reecht
###
####################################################################################################
### Description:
###
### Fonctions sp�cifiques aux observations de type Line Intercept Transect (LIT ; benthos)
### pour le calcul des tables de m�triques :
####################################################################################################

calc.unitSp.LIT.f <- function(obs, unitobs, dataEnv)
{
    ## Purpose: Calcul de la table de m�trique par unit� d'observation par
    ##          esp�ce pour le protocole benthos LIT
    ## ----------------------------------------------------------------------
    ## Arguments: obs : table des observations (data.frame).
    ##            unitobs : table des unit�s d'observation (data.frame).
    ##            dataEnv : environnement des donn�es.
    ## ----------------------------------------------------------------------
    ## Author: Yves Reecht, Date: 23 d�c. 2011, 18:22

    ## Calcul des nombres par cl / esp�ces / unitobs :
    nbr <- calcNumber.default.f(obs,
                                factors=c("observation.unit", "species.code"))

    ## Cr�ation de la data.frame de r�sultats (avec nombres, unitobs, ):
    res <- calc.numbers.f(nbr)


    ## Taille de transect :
    transectSz <- tapply(res[ , "number"], res[ , "observation.unit"], sum, na.rm=TRUE)

    ## Pourcentage de recouvrement de chaque esp�ce/categorie pour les couvertures biotiques et abiotiques :
    res[ , "coverage"] <- as.vector(100 * res[ , "number"] /
                                        transectSz[match(res[ , "observation.unit"],
                                                         rownames(transectSz))])
    rm(transectSz)

    ## Nombre de colonies (longueurs de transition > 0) :
    obs$count <- ifelse(obs[ , "number"] > 0, 1, 0) # [???] isTRUE ?  [yr: 3/1/2012]

    res[ , "colonies"] <- as.vector(tapply(obs$count,
                                          as.list(obs[ , c("observation.unit", "species.code")]),
                                          sum, na.rm=TRUE))

    res[ , "colonies"][is.na(res[ , "colonies"])] <- 0 # [???]

    ## Si les nombres sont des entiers, leur redonner la bonne classe :
    if (isTRUE(all.equal(res[ , "colonies"], as.integer(res[ , "colonies"]))))
    {
        res[ , "colonies"] <- as.integer(res[ , "colonies"])
    }else{}


    res[ , "mean.size.colonies"] <- apply(res[ , c("number", "colonies")], 1,
                                           function(x)
                                       {
                                           ifelse(x[2] == 0, NA, x[1] / x[2])
                                       })

    ## Pr�sence/absence :
    res[ , "pres.abs"] <- calc.presAbs.f(Data=res)

    return(res)
}








### Local Variables:
### ispell-local-dictionary: "english"
### fill-column: 120
### End:
