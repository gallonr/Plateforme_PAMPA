#-*- coding: latin-1 -*-
# Time-stamp: <2019-02-03 15:16:45 yreecht>

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

### File: boxplots_ttesp_generic.R
### Created: <2012-01-10 18:14:11 yreecht>
###
### Author: Yves Reecht
###
####################################################################################################
### Description:
###
###
####################################################################################################

########################################################################################################################
WP2boxplot.unitobs.f <- function(metrique, factGraph, factGraphSel, listFact, listFactSel, tableMetrique, dataEnv,
                                 baseEnv=.GlobalEnv)
{
    ## Purpose: Produire les boxplots en tenant compte des options graphiques
    ## ----------------------------------------------------------------------
    ## Arguments: metrique : la m�trique choisie.
    ##            factGraph : le facteur s�lection des esp�ces.
    ##            factGraphSel : la s�lection de modalit�s pour ce dernier
    ##            listFact : liste du (des) facteur(s) de regroupement
    ##            listFactSel : liste des modalit�s s�lectionn�es pour ce(s)
    ##                          dernier(s)
    ##            tableMetrique : nom de la table de m�triques.
    ##            dataEnv : environnement de stockage des donn�es.
    ##            baseEnv : environnement de l'interface.
    ## ----------------------------------------------------------------------
    ## Author: Yves Reecht, Date:  6 ao�t 2010, 16:34

    pampaProfilingStart.f()

    ## Nettoyage des facteurs (l'interface de s�lection produit des valeurs vides) :
    listFactSel <- listFactSel[unlist(listFact) != ""]
    listFactSel <- listFactSel[length(listFactSel):1]

    listFact <- listFact[unlist(listFact) != ""]
    listFact <- listFact[length(listFact):1]

    ## Concat�nation
    facteurs <- c(factGraph, unlist(listFact)) # Concat�nation des facteurs

    selections <- c(list(factGraphSel), listFactSel) # Concat�nation des leurs listes de modalit�s s�lectionn�es

    ## Donn�es pour la s�rie de boxplots :
    if (tableMetrique == "unit")
    {
        ## Pour les indices de biodiversit�, il faut travailler sur les nombres... :
        tmpData <- subsetToutesTables.f(metrique=getOption("P.nbName"), facteurs=facteurs,
                                        selections=selections, dataEnv=dataEnv, tableMetrique="unitSp",
                                        exclude = NULL, add=c("observation.unit", "species.code"))
    }else{
        ## ...sinon sur la m�trique choisie :
        tmpData <- subsetToutesTables.f(metrique=metrique, facteurs=facteurs,
                                        selections=selections, dataEnv=dataEnv, tableMetrique=tableMetrique,
                                        exclude = NULL, add=c("observation.unit", "species.code"))
    }

    ## Formule du boxplot
    exprBP <- eval(parse(text=paste(metrique, "~", paste(listFact, collapse=" + "))))

    ## Identification des diff�rents modalit�s (esp�ces) du graphique � g�n�rer :
    if (factGraph == "")                # Pas de facteur de s�paration des graphiques.
    {
        iFactGraphSel <- ""
    }else{
        if (is.na(factGraphSel[1]))            # Toutes les modalit�s.
        {
            iFactGraphSel <- unique(as.character(sort(tmpData[ , factGraph])))
        }else{                              # Modalit�s s�lectionn�es (et pr�sentes parmi les donn�es retenues).
            iFactGraphSel <- factGraphSel[is.element(factGraphSel, tmpData[ , factGraph])]
        }
    }

    ## Agr�gation des observations / unit� d'observation :
    if (tableMetrique == "unitSpSz" && factGraph != "size.class")
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
        }else{
            tmpData <- na.omit(agregationTableParCritere.f(Data=tmpData,
                                                           metrique=metrique,
                                                           facteurs=c("observation.unit"),
                                                           dataEnv=dataEnv,
                                                           listFact=listFact))
        }
    }

    ## Sauvegarde temporaire des donn�es utilis�es pour les graphiques (attention : �cras�e � chaque nouvelle s�rie de
    ## graphiques) :
    DataBackup <<- list(tmpData)

    ## Cr�ation du graphique si le nombre d'observations  < au minimum d�fini dans les options :
    if (nrow(tmpData) < getOption("P.MinNbObs"))
    {
        warning(mltext("WP2boxplot.W.n.1"), " (",
                paste(iFactGraphSel, collapse=", "), ") < ", getOption("P.MinNbObs"),
                mltext("WP2boxplot.W.n.2"))
    }else{

        ## Suppression des 'levels' non utilis�s :
        tmpData <- dropLevels.f(tmpData)

        ## Ouverture et configuration du p�riph�rique graphique :
        graphFile <- openDevice.f(noGraph=1,
                                  metrique=metrique,
                                  factGraph=factGraph,
                                  modSel=iFactGraphSel,
                                  listFact=listFact,
                                  dataEnv=dataEnv,
                                  type=ifelse(tableMetrique == "unitSpSz" && factGraph != "size.class",
                                              "CL_unitobs",
                                              "unitobs"),
                                  typeGraph="boxplot")

        par(mar=c(9, 5, 8, 1), mgp=c(3.5, 1, 0)) # param�tres graphiques.

        ## Titre (d'apr�s les m�triques, modalit� du facteur de s�paration et facteurs de regroupement) :
        mainTitle <- graphTitle.f(metrique=metrique,
                                  modGraphSel=iFactGraphSel,
                                  factGraph=factGraph,
                                  listFact=listFact,
                                  type=ifelse(tableMetrique == "unitSpSz" && factGraph != "size.class",
                                              "CL_unitobs",
                                              ifelse(tableMetrique == "unitSpSz",
                                                     "unitobs(CL)",
                                                     "unitobs")),
                                  graphType = "boxplot")

        ## Label axe y :
        ylab <- ifelse(getOption("P.axesLabels"),
                       parse(text=paste("\"", Capitalize.f(varNames[metrique, "nom"]), "\"",
                             ifelse(varNames[metrique, "unite"] != "",
                                    paste("~~(", varNames[metrique, "unite"], ")", sep=""),
                                    ""),
                             sep="")),
                       "")

        ## Boxplot !
        tmpBP <- boxplotPAMPA.f(exprBP, data=tmpData,
                                main=mainTitle, ylab=ylab)  ## Capitalize.f(varNames[metrique, "nom"]),


        ## #################### Informations suppl�mentaires sur les graphiques ####################

        ## S�parateurs de facteur de premier niveau :
        if (getOption("P.sepGroupes"))
        {
            sepBoxplot.f(terms=attr(terms(exprBP), "term.labels"), data=tmpData)
        }

        ## S�parateurs par d�faut :
        abline(v = 0.5+(0:length(tmpBP$names)) , col = "lightgray", lty = "dotted") # S�parations.

        ## L�gende des couleurs (facteur de second niveau) :
        if (getOption("P.legendeCouleurs"))
        {
            legendBoxplot.f(terms=attr(terms(exprBP), "term.labels"), data=tmpData)
        }else{}

        ## Moyennes :
        Moyenne <- as.vector(tapply(X=tmpData[, metrique], # moyenne par groupe.
                                    INDEX=as.list(tmpData[ , attr(terms(exprBP),
                                                                     "term.labels"), drop=FALSE]),
                                    FUN=mean, na.rm=TRUE))

        ## ... points :
        if (getOption("P.pointMoyenne"))
        {
            points(Moyenne,
                   pch=getOption("P.pointMoyennePch"),
                   col=getOption("P.pointMoyenneCol"), lwd=2.5,
                   cex=getOption("P.pointMoyenneCex"))
        }else{}

        ## ... valeurs :
        if (getOption("P.valMoyenne"))
        {
            plotValMoyennes.f(moyennes=Moyenne, objBP=tmpBP)
        }else{}

        if (isTRUE(getOption("P.warnings")))
        {
            ## Avertissement pour les petits effectifs :
            plotPetitsEffectifs.f(objBP=tmpBP, nbmin=5)
        }else{}

        ## Nombres d'observations :
        if (getOption("P.NbObs"))
        {
            nbObs <- tmpBP$n # Retourn� par la fonction 'boxplot'

            ## Nombres sur l'axe sup�rieur :
            axis(3, as.vector(nbObs), at=1:length(as.vector(nbObs)),
                 col.ticks=getOption("P.NbObsCol"), col.axis = getOption("P.NbObsCol"),
                 lty = 2, lwd = 0.5,
                 mgp=c(2, 0.5, 0))

            legend("topleft", mltext("WP2boxplot.n.rec", language = getOption("P.lang")),
                   cex =0.9, col=getOption("P.NbObsCol"), text.col=getOption("P.NbObsCol"), merge=FALSE)
        }else{}

        ## ##################################################
        ## Sauvegarde des donn�es :
        if (getOption("P.saveData"))
        {
            writeData.f(filename=graphFile, Data=tmpData,
                        cols=NULL)
        }else{}

        ## Sauvegarde des infos sur les donn�es et statistiques :
        if (getOption("P.saveStats"))
        {
            infoStats.f(filename=graphFile, Data=tmpData, agregLevel="unitobs", type="graph",
                        metrique=metrique, factGraph=factGraph, factGraphSel=factGraphSel,
                        listFact=rev(listFact), listFactSel=rev(listFactSel), # On les remets dans un ordre intuitif.
                        dataEnv=dataEnv, baseEnv=baseEnv)
        }else{}

        ## On ferme les p�riph�riques PDF :
        if (getOption("P.graphPDF") || isTRUE(getOption("P.graphPNG")))
        {
            dev.off()

            ## Inclusion des fontes dans le pdf si souhait� :
            if (getOption("P.graphPDF") && getOption("P.pdfEmbedFonts"))
            {
                tryCatch(embedFonts(file=graphFile),
                         error=function(e)
                     {
                         warning(mltext("WP2boxplot.W.pdfFonts"))
                     })
            }

        }else{
            if (.Platform$OS.type == "windows" && isTRUE(getOption("P.graphWMF")))
            {
                ## Sauvegarde en wmf si pertinent et souhait� :
                savePlot(graphFile, type="wmf", device=dev.cur())
            }else{}
        }
    }  ## Fin de graphique.

    pampaProfilingEnd.f()
}






### Local Variables:
### ispell-local-dictionary: "english"
### fill-column: 120
### End:
