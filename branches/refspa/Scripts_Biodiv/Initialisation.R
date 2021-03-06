#-*- coding: latin-1 -*-

## Plateforme PAMPA de calcul d'indicateurs de ressources & biodiversit�
##   Copyright (C) 2008-2012 Ifremer - Tous droits r�serv�s.
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

### File: Initialisation.R
### Time-stamp: <2012-01-15 20:35:45 yves>
###
### Author: Yves Reecht
###
####################################################################################################
### Description:
###
### Script destin� � recevoir les initialisations pr�c�demment faites dans Config.R
####################################################################################################

## Variables de fichiers requises:
options(P.requiredVar=c(unitobs="fileNameUnitobs",
                        obs="fileNameObs",
                        refesp="fileNameRefesp",
                        ws="nameWorkspace"))

## Options du r�f�rentiel spatial :
options(P.linkUnitobs="site",
        P.linkRefspa="CODE.SITE",
        P.shapefileEncoding="latin1")

## Option de noms de champs :
options(P.MPAfield="cas.etude")

## ##################### Initialisation des variables globales ####################

#### Logo :
.fileimage <- "./Scripts_Biodiv/img/pampa2.GIF"
assign(".fileimage", .fileimage, envir=.GlobalEnv)

#### Image de lien de tables :
.fileimageLink <- "./Scripts_Biodiv/img/tableLink.GIF"
assign(".fileimageLink", .fileimageLink, envir=.GlobalEnv)


########################################################################################################################
## Ajouts pour les graphs g�n�riques [yr: 13/08/2010] :

## Noms d'usage des variables des principales tables de donn�es
## (r�f�rentiels compris) :
init.GraphLang.f <- function()
{
    ## Purpose: Initialisation de la langue utilis�e pour les noms de
    ## variables sur les graphiques.
    ## ----------------------------------------------------------------------
    ## Arguments: aucun (bas� sur les options).
    ## ----------------------------------------------------------------------
    ## Author: Yves Reecht, Date: 17 nov. 2011, 10:22

    assign("varNames",
           read.csv(paste(basePath, "/Scripts_Biodiv/NomsVariables_",
                          tolower(getOption("P.lang")), ".csv",
                          sep=""),
                    header=TRUE, row.names=1, stringsAsFactors=FALSE,
                    fileEncoding="latin1"),
           envir=.GlobalEnv)
}

## Remplacer "/Scripts_Biodiv/NomsVariables_fr.csv" par "/Scripts_Biodiv/NomsVariables_en.csv" pour des axes et noms de variables en
## anglais.
## Affecte uniquement les sorties !








### Local Variables:
### ispell-local-dictionary: "english"
### fill-column: 120
### End:
