#' Converting spatial polygon dataframes to dfs
#'
#' This function allows you to go from shp to df, and specify a projection
#' @param dsn The path from current working directory to the folder containing the shapefile
#' @param layer The name of the shapefile without the .shp
#' @keywords import
#' @importFrom sf st_read st_crs st_transform
#' @export

# requires rgdal, sp

readNZTM <- function(dsn, layer){

  nztm <- sf::st_crs(2193) 
  shp <- sf::st_read(dsn = dsn, layer = layer)

  shp2 <- sf::st_transform(shp, nztm)

  return(shp2)
}

