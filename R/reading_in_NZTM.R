#' Converting spatial polygon dataframes to dfs
#'
#' This function allows you to go from shp to df, and specify a projection
#' @param dsn The path from current working directory to the folder containing the shapefile
#' @param layer The name of the shapefile without the .shp
#' @keywords import
#' @export
#' @examples

# requires rgdal, sp

readNZTM <- function(dsn, layer){

  nztm <- CRS("+proj=tmerc +lat_0=0 +lon_0=173 +k=0.9996 +x_0=1600000 +y_0=10000000 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs ")

  shp <- readOGR(dsn = dsn, layer = layer)

  shp2 <- spTransform(shp, nztm)

  return(shp2)
}

