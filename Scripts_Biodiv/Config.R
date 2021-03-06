## GUI language/Langues d'interface:
options(P.GUIlang="en")                 # en/fr implemented so far


## #########################################################################################################
## Path to automatically loaded files/ Chemin des fichiers utilis�s par le chargement automatique.
##
## Example below: replicate with your own file names/paths (without the comment signs, ##) /
## Exemple : faites de m�me avec vos jeux de donn�e (sans les commentaires - "## " - en d�but de ligne.) :

## #### <Study case> / <Cas d'�tude> :
## fileNameUnitobs <- "<unitobs_file.txt>"
## fileNameObs <- "<observations_file.txt>"
## fileNameRefesp <- "<global_species_reference_table.txt>"
## fileNameRefespLocal <- "<local_species_reference_table.txt>"
## fileNameRefspa <- "<spatial_reference_(table.txt|shapefile.shp)>"
## nameWorkspace <- "C:/PAMPA"



## #########################################################################################################
## EN: You can also tune the default graphics options:
##
## FR: Vous pouvez �galement d�finir des options par d�faut personnalis�es (donne �galement acc�s aux
##     options "cach�es") :

## options(P.colPalette="gray", P.pointMoyenneCol = "black", P.sepGroupesCol = "#6f6f6f",
##         P.valMoyenneCol = "black", P.NbObsCol = "black",
##         P.valMoyenne = FALSE, P.pointMoyenne = TRUE,
##         P.legendeCouleurs = FALSE, P.NbObs = FALSE,
##         P.graphPaper=TRUE)

## EN: If you change the language for the outputs, a further step is required:
## FR: Dans le cas ou vous changeriez la langue des sorties une �tape suppl�mentaire est n�cesaire :

## options(P.lang="en")
## init.GraphLang.f()          # Load the appropriate variable names file /
                               # Pour charger le bon fichier de noms de variables.


     #############################################
     ###    Paste your configuration below /   ###
     ### Collez votre configuration ci-dessous ###
     #############################################

