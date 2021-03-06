#-*- coding: latin-1 -*-
# Time-stamp: <2019-02-03 20:58:38 yreecht>

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

## le fichier gestionmessages.r a besoin du fichier Config.R pour �tre execut�
## les passages � la ligne se font � la fin des messages
## on retourne encore � la ligne avant une erreur

gestionMSGerreur.f <- function (nameerror, variable, env=.GlobalEnv)
{
    runLog.f(msg=c("Envoie d'un message d'erreur dans l'interface :"))

    ## Message :
    MSG <-
        switch(nameerror,
               "recouvrementsansLIT"={
                   paste(mltext("error.recouvrementsansLIT.1"),
                         mltext("error.recouvrementsansLIT.2"), sep="")
               },
               "noWorkspace"={
                   mltext("error.noWorkspace")
               },
               "nbChampUnitobs"={
                   paste(mltext("error.nbChampUnitobs.1"),
                         mltext("error.nbChampUnitobs.2"), sep="")
               },
               ## "nbChampUnitobs"={
               ##     paste("Votre fichier 'Unites d'observation' ne comporte pas le bon nombre de champs!",
               ##           " Il devrait en contenir 35. Corrigez le et recommencez l'importation.\n", sep="")
               ## },
               "nbChampEsp"={
                   paste(mltext("error.nbChampEsp.1"),
                         mltext("error.nbChampEsp.2"), sep="")
               },
               "nbChampObs"={
                   paste(mltext("error.nbChampObs.1"),
                         mltext("error.nbChampObs.2"), sep="")
               },
               "UnitobsDsObsUnitobs"={
                   paste(mltext("error.UnitobsDsObsUnitobs.1"),
                         mltext("error.UnitobsDsObsUnitobs.1"), sep="")
               },
               "CaractereInterditDsObs"={
                   mltext("error.CaractereInterditDsObs")
               },
               "CaractereInterditDsUnitObs"={
                   mltext("error.CaractereInterditDsUnitObs")
               },
               "ZeroEnregistrement"={
                   mltext("error.ZeroEnregistrement")
               },
               "UneSeuleValeurRegroupement"={
                   mltext("error.UneSeuleValeurRegroupement")
               },
               "CritereMalRenseigne50"={
                   paste(mltext("error.CritereMalRenseigne50.1"),
                         mltext("error.CritereMalRenseigne50.2"), sep="")
               },
               "CaractereInterdit"={
                   paste(mltext("error.CaractereInterdit.1"), variable,
                         mltext("error.CaractereInterdit.2"),
                         mltext("error.CaractereInterdit.3"), sep="")
               },
               ## Message par d�faut :
               mltext("error.noMsg"))

    ## gestionMSGerreur.f(nbChampUnitobs)
    ## langue = EN

    tkinsert(get("helpframe", envir=env), "end", paste(mltext("error.prefix"), MSG, sep=""))
    tkyview.moveto(get("helpframe", envir=env), 1)
}

gestionMSGaide.f <- function (namemsg, env=.GlobalEnv)
{
    runLog.f(msg=c(mltext("logmsg.helpmsg")))

    ## Message :
    MSG <-
        switch(namemsg,
               "ZeroEnregistrement"={
                   paste(mltext("helpmsg.ZeroEnregistrement.1"),
                         mltext("helpmsg.ZeroEnregistrement.2"), sep="")
               },
               "etapeImport"={
                   paste(mltext("helpmsg.etapeImport.1"),
                         mltext("helpmsg.etapeImport.2"),
                         mltext("helpmsg.etapeImport.3"),
                         sep="")
               },
               "SelectionOuTraitement"={
                   paste(mltext("helpmsg.SelectionOuTraitement.1"),
                         mltext("helpmsg.SelectionOuTraitement.2"),
                         "\n", sep="")
               },
               ## "startsansficher"={
               ##     paste("Si les fichiers par d�fauts param�tr�s dans 'Config.R'- ", fileNameUnitobs, " - ",
               ##           fileNameObs, " - ",
               ##           fileNameRefesp, " ne sont pas les bons, Veuillez les modifier\n", sep="")
               ## },
               "etapeselected"={
                   paste(mltext("helpmsg.etapeselected.1"),
                         mltext("helpmsg.etapeselected.2"),
                         mltext("helpmsg.etapeselected.3"),
                         mltext("helpmsg.etapeselected.4"),
                         sep="")
               },
               "message � d�finir")

    tkinsert(get("helpframe", envir=env), "end", paste("\n", MSG, "", sep=""))
    tkyview.moveto(get("helpframe", envir=env), 1)
}

########################################################################################################################
add.logFrame.f <- function(msgID, env=dataEnv,...)
{
    ## Purpose: Ajout de messages dans le cadre d'info sur les chargements
    ##          et s�lections.
    ## ----------------------------------------------------------------------
    ## Arguments: msgID : identifiant du type de message.
    ##            env : environnement o� est d�finit le cadre d'information
    ##                  (interface).
    ##            ... : arguments suppl�mentaires (dont l'existence est
    ##                  test�e en fonction du type de message choisi.)
    ## ----------------------------------------------------------------------
    ## Author: Yves Reecht, Date:  9 nov. 2011, 16:01

    ## On r�cup�re les arguments suppl�mentaires sous une forme facilement utilisable (list) :
    argsSup <- list(...)

    ## Traitement des diff�rents cas de message :
    msg <- switch(msgID,
                  "dataLoadingNew"={
                      if (any(!is.element("filePathes",
                                          names(argsSup))))
                      {
                          stop("Wrong argument(s)!")
                      }else{
                          paste("",
                                paste(rep("=", 100), collapse=""),
                                paste(mltext("logFmsg.loading"),
                                      format(Sys.time(), "%d/%m/%Y\t%H:%M:%S"),
                                      ")", sep=""),

                                paste(mltext("logFmsg.obsFile"), argsSup$filePathes["obs"]),
                                paste(mltext("logFmsg.unitobsFile"), argsSup$filePathes["unitobs"]),
                                paste(mltext("logFmsg.refespFile"), argsSup$filePathes["refesp"]),
                                ifelse(is.na(argsSup$filePathes["refspa"]), "",
                                       paste(mltext("logFmsg.refspaFile"), argsSup$filePathes["refspa"])),
                                paste(mltext("logFmsg.exportPath"), argsSup$filePathes["results"]),
                                "\n", sep="")
                      }
                  },
                  "restauration"={
                      paste("",
                            paste(rep("-", 80), collapse=""),
                            paste(mltext("logFmsg.restoreData"),
                                  format(Sys.time(), "%d/%m/%Y\t%H:%M:%S"),
                                  ")", sep=""),
                            "\n", sep="\n")
                  },
                  "selection"={
                      if (any(!is.element(c("facteur", "selection", "results", "referentiel", "has.SzCl"),
                                          names(argsSup))))
                      {
                          stop("Wrong argument(s)!")
                      }else{
                          paste("\n",
                                paste(rep("-", 100), collapse=""),
                                paste(mltext("logFmsg.selection.1"),
                                      ifelse(argsSup$referentiel == "especes",
                                             mltext("logFmsg.selection.2"),
                                             mltext("logFmsg.selection.3")),
                                      " (",
                                      format(Sys.time(), "%d/%m/%Y\t%H:%M:%S"),
                                      ")", sep=""),
                                paste(mltext("logFmsg.selection.4"), argsSup$facteur),
                                paste(mltext("logFmsg.selection.5"),
                                      paste(argsSup$selection, collapse=", ")),
                                paste(mltext("logFmsg.selection.6"), argsSup$results, " :", sep=""),
                                ifelse(isTRUE(argsSup$has.SzCl),
                                       paste(mltext("logFmsg.selection.7"),
                                             "UnitobsEspeceClassetailleMetriques_selection.csv"),
                                       ""),
                                paste(mltext("logFmsg.selection.8"),
                                      "UnitobsEspeceMetriques_selection.csv"),
                                paste(mltext("logFmsg.selection.9"),
                                      "UnitobsMetriques_selection.csv"),
                                paste(mltext("logFmsg.selection.10"),
                                      "PlanEchantillonnage_basique_selection.csv"),
                                "\n\n", sep="")
                      }
                  },
                  "fichiers"={
                      if (any(!is.element(c("results", "has.SzCl"),
                                          names(argsSup))))
                      {
                          stop("Wrong argument(s)!")
                      }else{
                          paste("\n",
                                paste(rep("-", 100), collapse=""),
                                paste(mltext("logFmsg.files.1"), argsSup$results, sep=""),
                                paste("\n   (avant ", format(Sys.time(), "%d/%m/%Y\t%H:%M:%S"), ") :", sep=""),
                                ifelse(isTRUE(argsSup$has.SzCl),
                                       paste(mltext("logFmsg.files.2"),
                                             "UnitobsEspeceClassetailleMetriques.csv"),
                                       ""),
                                paste(mltext("logFmsg.files.3"),
                                      "UnitobsEspeceMetriques.csv"),
                                paste(mltext("logFmsg.files.4"),
                                      "UnitobsMetriques.csv"),
                                paste(mltext("logFmsg.files.5"),
                                      "PlanEchantillonnage_basique.csv"),
                                "\n\n", sep="")
                      }
                  },
                  "InfoRefSpeEnregistre"={
                      if (any(!is.element(c("file"),
                                          names(argsSup))))
                      {
                          stop("Wrong argument(s)!")
                      }else{
                          paste("",
                                paste(rep("-", 100), collapse=""),
                                mltext("logFmsg.saveInfoRefspe.1"),
                                paste("   ", argsSup$file, format(Sys.time(), "  (%d/%m/%Y\t%H:%M:%S)"), sep=""),
                                "\n", sep="\n")
                      }
                  },
                  "TableSavedCSV"={
                      if (any(!is.element(c("file"),
                                          names(argsSup))))
                      {
                          stop("Wrong argument(s)!")
                      }else{
                          paste("",
                                paste(rep("-", 100), collapse=""),
                                mltext("logFmsg.saveTableCSV"),
                                paste("   ", argsSup$file, format(Sys.time(), "  (%d/%m/%Y\t%H:%M:%S)"), sep=""),
                                "\n", sep="\n")
                      }
                  },
                  "")

    ## Ajout du message :
    tkinsert(get("txt.w", envir=env), "end", msg)
    tkyview.moveto(get("txt.w", envir=env), 1)
}




