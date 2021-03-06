#-*- coding: latin-1 -*-
# Time-stamp: <2018-08-23 17:19:32 yreecht>

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

### File: Load_shapefile.R
### Created: <2012-11-19 14:58:51 yves>
###
### Author: Yves Reecht
###
####################################################################################################
### Description:
###
### Chargement et traitement du shapefile de r�f�rentiel spatial (optionel).
####################################################################################################

########################################################################################################################
loadShapefile.f <- function(directory, layer)
{
    ## Purpose: Load the spatial reference object from a shapefile.
    ## ----------------------------------------------------------------------
    ## Arguments: directory : where the shapefile is located.
    ##            layer : layer name (filname, without extension).
    ## ----------------------------------------------------------------------
    ## Author: Yves Reecht, Date: 19 nov. 2012, 17:12

    ## Read the shapefile :
    refspa <- readOGR(dsn=directory, layer=layer,
                      encoding=getOption("P.shapefileEncoding"), verbose=FALSE)

    colnames(refspa@data) <- gsub("_", ".", colnames(refspa@data), fixed=TRUE)
    colnames(refspa@data)[1] <- "OBJECTID"

    ## Define the coordinate (without projection) for surface area processing :
    crsArea <- CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0")

    refspa <- spCbind(refspa,
                      data.frame("SITE.SURFACE"=areaPolygon(spTransform(x=refspa,
                                                                        CRSobj=crsArea)) / (10^6), # en km� !
                                 row.names=row.names(refspa@data)))

    ## Add centroids :
    tmpCentr <- as.data.frame(coordinates(refspa),
                              row.names=row.names(refspa@data))

    colnames(tmpCentr) <- paste("SITE.centr", c("X", "Y"), sep="")

    refspa <- spCbind(refspa,
                      tmpCentr)

}

########################################################################################################################
overlayUnitobs.f <- function(unitobs, refspa)
{
    ## Purpose: Attribute the observation units to zones of the
    ##          spatial reference table.
    ## ----------------------------------------------------------------------
    ## Arguments: unitobs : observation unit table.
    ##            refspa : spatial reference object
    ##                     ("SpatialPolygonsDataFrame").
    ## ----------------------------------------------------------------------
    ## Author: Yves Reecht, Date: 20 nov. 2012, 17:35

    ## Georefences unitobs :
    spaUnitobs <- SpatialPointsDataFrame(coords=cbind(x=unitobs$longitude,
                                                      y=unitobs$latitude),
                                         data=unitobs,
                                         proj4string=refspa@proj4string,
                                         match.ID=TRUE)

    ## Create the link to zones :
    unitobs <- cbind(unitobs,
                     "OBJECTID"=as.character(over(x=spaUnitobs, y=refspa)[ , "OBJECTID"]))

    return(unitobs)
}






### Local Variables:
### ispell-local-dictionary: "english"
### fill-column: 120
### End:
