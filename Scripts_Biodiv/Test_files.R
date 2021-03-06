#-*- coding: latin-1 -*-
# Time-stamp: <2019-02-03 18:05:17 yreecht>

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

## essais de rendre g�n�rique apr�s avec unitobs et obs
testfileref.f <- function (dataEnv, baseEnv)
{
    ## Get the data :
    filePathes <- get("filePathes", envir=dataEnv)
    fileNames <- get("fileNames", envir=dataEnv)
    refesp <- get("refesp", envir=dataEnv)
    obs <- get("obs", envir=dataEnv)

    imageAMP <- get("imageAMP", envir=baseEnv)

    runLog.f(msg=c(mltext("logmsg.info.spref")))

    tclRequire("Tktable")
    ## Declaration of window and table objects:
    W.test <- tktoplevel(width = 100)
    tclarrayRefEsp <- tclArray()

    ## Functions associated with window's buttons:
    FermerWinTest <- function ()
    {
        tkdestroy(W.test)
        ## winRaise.f(W.main)
    }

    EnregistrerWinTest <- function ()
    {
        FichierCSV <- paste(filePathes["results"], "Info_",
                            sub(pattern = "\\.[^.]{1,4}$",
                                replacement = "",
                                fileNames["refesp"]),
                            ".csv", sep="")
        write.csv(dataframeRefEsp, file=FichierCSV, row.names = FALSE)

        add.logFrame.f(msgID="InfoRefSpeEnregistre", env = baseEnv, file=FichierCSV)
    }

    ## D�claration des objets bouton
    Fermer.but <- tkbutton(W.test, text=mltext("filetest.B.close"), command=FermerWinTest)
    Enregistrer.but <- tkbutton(W.test, text=mltext("filetest.B.save.csv"), command=EnregistrerWinTest)

    ## S�lection des valeurs de la table esp�ces correspondant au jeux de donn�es
    sites <- getOption("P.MPA")
    espSite <- paste("Obs", sites, sep="")

    especes.select <- dropLevels.f(subset(refesp,
                                          is.element(species.code, levels(obs$species.code))))

    ## Externaliser la d�finition des sites par la suite...
    listeSite <- c("RUN" , "MAY" , "BA" , "BO" , "CB" , "CR" , "STM" , "NC")

    ## Noms des sites dont on doit exclure les colonnes :
    sitesExclus <- listeSite[ ! grepl(pattern=paste("^(",
                                                    paste(sites, collapse="|"),
                                                    ")$", sep=""), x=listeSite)]

    ## champs ne correspondant pas au motif "(Site1|Site2|...)$" :
    champsSite <- colnames(especes.select)[! grepl(paste("(", paste(sitesExclus, collapse="|"), ")$", sep=""),
                                                   colnames(especes.select))]

    especes.select <- especes.select[ , champsSite]

    ## construction de l'objet dataframe
    dataframeRefEsp <- as.data.frame(names(refesp))
    colnames(dataframeRefEsp)[1] <- mltext("filetest.arr.fieldName")
    dataframeRefEsp[, 2] <- ""
    dataframeRefEsp[, 3] <- ""
    colnames(dataframeRefEsp)[2] <- mltext("filetest.arr.nbVal")
    colnames(dataframeRefEsp)[3] <- mltext("filetest.arr.pcFilled")

    ## construction de l'objet tableau
    tclarrayRefEsp[[0, 0]] <- mltext("filetest.arr.0.0")
    tclarrayRefEsp[[0, 1]] <- mltext("filetest.arr.0.1")
    tclarrayRefEsp[[0, 2]] <- mltext("filetest.arr.0.2")
    tclarrayRefEsp[[0, 3]] <- mltext("filetest.arr.0.3")

    for (nbChamp in (1:dim(especes.select)[2]))
    {
        ## Remplissage du tableau
        tclarrayRefEsp[[nbChamp, 0]] <- nbChamp
        tclarrayRefEsp[[nbChamp, 1]] <- names(especes.select)[nbChamp]
        tclarrayRefEsp[[nbChamp, 2]] <- sum(!is.na(especes.select[, nbChamp]))

        tclarrayRefEsp[[nbChamp, 3]] <-
            paste(round(sum(!is.na(especes.select[ , nbChamp])) /
                        nrow(especes.select) * 100, digits=2), "%")

        ## Remplissage du dataframe pour l'enregistrement
        dataframeRefEsp[nbChamp, 2] <- sum(!is.na(especes.select[, nbChamp]))
        dataframeRefEsp[nbChamp, 3] <-
            paste(round(sum(!is.na(especes.select[ , nbChamp])) /
                        nrow(especes.select) * 100, digits=2), "%")
    }

    ## construction de la fen�tre
    tkwm.title(W.test, paste(mltext("filetest.info"))) ## fileNames["refesp"]))
    frameOverwintest <- tkframe(W.test)
    imgAsLabelwintest <- tklabel(frameOverwintest, image=imageAMP, bg="white")


    tkgrid(frameOverwintest, sticky="ew", columnspan=2)

    tkgrid(imgAsLabelwintest,
           tklabel(frameOverwintest,
                   text=paste(mltext("filetest.frameOverwintest.1"), ## fileNames["refesp"],
                              mltext("filetest.frameOverwintest.2"), ## fileNames["obs"]),
                              fileNames["refesp"],
                              ifelse(! is.na(fileNames["locrefesp"]),
                                     paste0(" ", mltext("KW.and"), "\n ", fileNames["locrefesp"]),
                                     "")),
                   relief="groove", borderwidth=2,
                   bg="yellow", justify="left"),
           padx=5, sticky="e")

    tkgrid.configure(imgAsLabelwintest, sticky="w")

    ## tkgrid.configure(frameOverwintest, columnspan=1, column=1)
    tkgrid(tklabel(W.test, text=paste(mltext("filetest.W.test.1"), fileNames["refesp"],
                                      mltext("colon"),
                                      dim(especes.select)[2])),
           Enregistrer.but)

    tkgrid(tklabel(W.test,
                   text=paste(mltext("filetest.W.test.2"),
                              paste(sites, collapse=", "),
                              mltext("colon"),
                              tryCatch(nrow(subset(refesp,
                                                   apply(refesp[, espSite, drop=FALSE], 1,
                                                         function(x) any(tolower(x) %in%
                                                                         tolower(c("oui", "yes",
                                                                                   mltext("KW.yes"))))))),
                                       error = function(e)
                                       {
                                           warning("No filed ('", paste(espSite, collapse = "', '"),
                                                   "') in the reference table")
                                           return(NA)
                            }))))

    tkgrid(tklabel(W.test,
                   text=paste(mltext("filetest.W.test.3"), fileNames["obs"], " : ",
                   length(unique(obs$species.code)))), Fermer.but)

    tkgrid(tklabel(W.test,
                   text=paste(## "\nInformations sur les ", length(unique(obs$species.code)),
                              ## "esp�ces \nDU JEU DE DONNEES ",
                              mltext("filetest.W.test.4"), sep="")))

    tableTestRefEsp <- tkwidget(W.test, "table",
                                variable=tclarrayRefEsp, rows=ncol(especes.select) + 1, cols=4,
                                colwidth=27, titlerows=1, titlecols=1, selectmode="extended", background="white",
                                xscrollcommand=function(...) {tkset(xscr, ...)},
                                yscrollcommand=function(...) {tkset(yscrtb, ...)})

    xscr <-tkscrollbar(W.test, orient="horizontal", command=function(...)tkxview(tableTestRefEsp, ...))
    yscrtb <- tkscrollbar(W.test, command=function(...)tkyview(tableTestRefEsp, ...))
    tkgrid(tableTestRefEsp, yscrtb, columnspan=3)
    tkgrid.configure(yscrtb, sticky="nsw")
    tkgrid(xscr, sticky="new", columnspan=3)

    tkconfigure(tableTestRefEsp, variable=tclarrayRefEsp, background="white", selectmode="extended",
                rowseparator="\"\n\"", colseparator="\"\t\"")

    tkgrid.configure(tableTestRefEsp, columnspan=2, sticky="w")
    ## barplot(dataframeRefEsp)
    tkfocus(W.test)
    winSmartPlace.f(W.test)
}
