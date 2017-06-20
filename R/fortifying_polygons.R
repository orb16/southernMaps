#' Converting spatial polygon dataframes to dfs
#'
#' This function allows you to go from shp to df, and specify a projection
#' @param shape The name of your shapefile object
#' @param proj The name of the projection. Currently either only "wgs84" or "nztm"
#' @keywords transform reproject
#' @export
#' @examples


fortify_polygons <- function(shape, proj){

  nztm <- CRS("+proj=tmerc +lat_0=0 +lon_0=173 +k=0.9996 +x_0=1600000 +y_0=10000000 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs ")
  wgs84 <- CRS("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs ")

  if(class(shape) != "SpatialPolygonsDataFrame"){
    stop("function only to be used for SpatialPolygonsDataFrame, use fortify_points() for points")
  }

  if(proj %in% c("NZTM", "nztm")){
    shapell <- spTransform(shape, CRSobj = nztm)
  } else if(proj %in% c("WGS84", "wgs84")){
    shapell <- spTransform(shape, CRSobj = wgs84)
  } else{
    stop("Only nztm and wgs84 projections currently allowed. Submit a pull request or issue if you want another one")
  }
  shapell@data$id <- rownames(shapell@data)
  fortified <- tidy(shapell, region = "id")
  newname = merge(fortified, shapell@data)
  return(newname)
}
