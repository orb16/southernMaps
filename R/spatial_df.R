#' spatial_df
#'
#' @param data dataframe with coords and other data in
#' @param xcol name of column with x coords in
#' @param ycol name of column with y coords in
#' @param crs CRS object. Can be from find_CRS
#'
#' @return spatialpointsdataframe
#' @export
#'
#' @examples
#' tp <- data.frame(
#' Island = c("South Island", "North Island",
#' "North Island", "Stewart Island", "South Island"),
#' City = c("Christchurch", "Wellington", "Auckland", "Oban", "Dunedin"),
#' long = c(172.63333,174.77557, 174.76667, 168.12736, 170.50361),
#' lat = c(-43.53333, -41.28664, -36.86667, -46.89881, -45.87416))
#'
#' wgs84 <- st_crs(4326)
#' # we know nztm is espg2193
#' nztm <- find_CRS(epsg = "2193")
#'
#' spatialCities <- spatial_df(data = tp, xcol = "long", ycol = "lat",
#' crs = wgs84)
#'
#' cols <- c("forestgreen", "navyblue", "violetred4")
#' isl <- c("North Island", "South Island", "Stewart Island")
#'
#' mapColours <- data.frame(cols = I(cols), isl)
#'
#' plot(nzSml84, col  = "grey", border = NA)
#' text(spatialCities, col = mapColours$cols[match(spatialCities$Island, mapColours$isl)],
#' label = spatialCities$City, cex = 1)
#' legend("topleft", text.col = mapColours$cols,
#' legend = mapColours$isl,
#' pch = 16)


spatial_df <- function(data, xcol, ycol, crs){

  st_as_sf(data, coords = c(xcol, ycol), 
           crs = crs)

}


