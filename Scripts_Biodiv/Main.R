#-*- coding: latin-1 -*-
# Time-stamp: <2019-01-23 18:15:35 yreecht>

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

### File: Main.R
### Created: <2012-02-24 20:36:47 Yves>
###
### Author: Yves Reecht
###
####################################################################################################
### Description:
###
### Objet            : Programme de calcul des m�triques "ressources & biodiversit�".
### Date de cr�ation : F�vrier 2008
###
####################################################################################################

## ** Version **
options(versionPAMPA = "3.0-beta2",
        defaultLang = "en")

## Platform-specific treatment:
## Identification du dossier parent (d'installation) :
fileCall <- sub("source\\([[:blank:]]*(file[[:blank:]]*=[[:blank:]]*)?(\"|\')([^\"\']*)(\"|\')[[:blank:]]*(,.*\\)|\\))",
                "\\3",
                paste(deparse(tryCatch(sys.call(-2),
                                       error=function(e) {NULL})),
                      collapse=""))

## R�glage du dossier de travail de R :
if(basename(fileCall) == "Main.R")
{
    setwd(paste(dirname(fileCall), "/../", sep=""))
}else{
    ## message("Dossier non-trouv�")
    if (.Platform$OS.type == "windows")
    {
        setwd("C:/PAMPA/")
    }else{}                             # Rien !
}

## R�cup�r� dans une variable globale (beurk !) :
basePath <- getwd()

## Load configuration:
.Config <- parse(file.path(basePath, "Scripts_Biodiv/Config.R"), encoding = "latin1")

## R�pertoire de travail:
if (length(idxWD <- grep("^[[:blank:]]*nameWorkspace[[:blank:]]*(<-|=)", .Config)))
{
    eval(.Config[[idxWD]])
}else{
    ## ...par d�faut (si pas configur� par ailleurs) :
    nameWorkspace <- basePath
}

## #############################################################################################################
## Chargement des fonctions de la plateforme pour :
                                                                                       # Code formating
                                                                                       # [ML status]:
## ...les fonctions communes de base :                                                 # -----------------------
source("./Scripts_Biodiv/Load_packages.R", encoding="latin1")                          # OK [mld]
source("./Scripts_Biodiv/Functions_base.R", encoding="latin1")                         # OK [mld]
source("./Scripts_Biodiv/Functions_Multilingual.R", encoding="latin1")                 # [mli]

## ...la cr�ation de l'interface :
source("./Scripts_Biodiv/Interface_functions.R", encoding="latin1")                    # OK [mld]
source("./Scripts_Biodiv/Interface_main.R", encoding="latin1")                         # OK [mld]

## anciennes fonctions annexes de visualisation des donn�es (corrig�es) :
source("./Scripts_Biodiv/Messages_management.R", encoding="latin1")                    # done [mld]
source("./Scripts_Biodiv/Test_files.R", encoding="latin1")                             # done [mld]
source("./Scripts_Biodiv/View.R", encoding="latin1")                                   # done [mld]

## ...le chargement des donn�es :
source("./Scripts_Biodiv/Load_files.R", encoding="latin1")                             # OK [mld]
source("./Scripts_Biodiv/Load_files_manually.R", encoding="latin1")                    # OK [mld]
source("./Scripts_Biodiv/Weight_calculation.R", encoding="latin1")                     # OK [mld]
source("./Scripts_Biodiv/Link_unitobs-refspa.R", encoding="latin1")                    # OK [mld]
source("./Scripts_Biodiv/Load_shapefile.R", encoding="latin1")                         # OK [mld]
source("./Scripts_Biodiv/Load_OBSIND.R", encoding="latin1")                            # OK [mli]

## ...les calculs de tables de m�triques :
source("./Scripts_Biodiv/Generic_aggregations.R", encoding="latin1")                   # OK [mld]
source("./Scripts_Biodiv/Calculate_metrics_tables.R", encoding="latin1")               # OK [mld]
source("./Scripts_Biodiv/Calculate_metrics_tables_LIT.R", encoding="latin1")           # OK [mli]
source("./Scripts_Biodiv/Calculate_metrics_tables_SVR.R", encoding="latin1")           # OK [mld]
source("./Scripts_Biodiv/Turtle_tracks.R", encoding="latin1")                          # OK [mld]

## ...la s�lection des donn�es :
source("./Scripts_Biodiv/Data_subsets.R", encoding="latin1")                           # OK [mld]

## ...options graphiques et g�n�rales :
source("./Scripts_Biodiv/Options.R", encoding="latin1")                                # OK [mld]

##################################################
## Analyses et graphiques :

## ...l'interface de s�lection des variables :
source("./Scripts_Biodiv/Variables_selection_functions.R", encoding="latin1")          # OK [mld]
source("./Scripts_Biodiv/Variables_selection_interface.R", encoding="latin1")          # OK [mld]

## ...la cr�ation de boxplots (...) :
source("./Scripts_Biodiv/Functions_graphics.R", encoding="latin1")                     # OK [mld]
source("./Scripts_Biodiv/Boxplots_generic_sp.R", encoding="latin1")                    # OK [mld]
source("./Scripts_Biodiv/Boxplots_generic_unitobs.R", encoding="latin1")               # OK [mld]
## ...dont cartes :
source("./Scripts_Biodiv/Maps_graphics.R", encoding="latin1")                          # [mld]
source("./Scripts_Biodiv/Maps_variables.R", encoding="latin1")                         # [mld]

## ...les analyses statistiques :
source("./Scripts_Biodiv/Linear_models_interface.R", encoding="latin1")                # OK [mld]
source("./Scripts_Biodiv/Linear_models_generic_sp.R", encoding="latin1")               # OK [mld]
source("./Scripts_Biodiv/Linear_models_generic_unitobs.R", encoding="latin1")          # OK [mld]
source("./Scripts_Biodiv/MRT_generic_unitobs.R", encoding="latin1")                    # OK [mld]
source("./Scripts_Biodiv/MRT_generic_sp.R", encoding="latin1")                         # OK [mld]

## ...les barplots sur les fr�quences d'occurrence :
source("./Scripts_Biodiv/Barplots_occurrence.R", encoding="latin1")                    # OK [mld]
source("./Scripts_Biodiv/Barplots_occurrence_unitobs.R", encoding="latin1")            # OK [mld]

## ...barplots g�n�riques :
source("./Scripts_Biodiv/Barplots_generic_sp.R", encoding="latin1")                    # OK [mld]
source("./Scripts_Biodiv/Barplots_generic_unitobs.R", encoding="latin1")               # OK [mld]

########################################################################################################################
## Configuration :
source("./Scripts_Biodiv/Initialisation.R", encoding="latin1")

## Initialization of options (new ~ persistent system):
if (is.null(getOption("PAMPAdummy")))   # uniquement si pas d�j� initialis�es (cas de lancement multiple)
{
    ## Index of
    idxOpt <- grep("^[[:blank:]]*options[[:blank:]]*\\(", .Config)

    ## Evaluate the options a first time
    ## (some - like the language options -
    ##  are persistent during the initialization):
    eval(.Config[idxOpt])

    if (is.null(getOption("P.GUIlang")))
    {
        options("P.GUIlang" = getOption("defaultLang"))
    }
    initialiseOptions.f()

    ## Override the non-persistent options after initialization:
    eval(.Config[idxOpt])
}


## options("P.GUIlang" = "fr")
## options(error = recover)
## On lance l'interface :
mainInterface.create.f()

#################### Tags de d�veloppement ####################
## [!!!] : construction dangereuse, capilo-tract�e ou erreur possible.
## [imb] : fonctions imbriqu�es dans d'autres fonctions (� corriger)
## [sll] : sans longueur des lignes (mise en forme du code pas termin�e)
## [inc] : expression/fonction incompl�te.
## [OK]  : probl�me corrig�.
## [???] : comprend pas !
## [sup] : supprim�.
## [dep] : d�plac� (menu).

## Translation tags:
## [mli]: irrelevant
## [mlo]: ongoing
## [mld]: Done


### Local Variables:
### ispell-local-dictionary: "english"
### fill-column: 120
### End:
