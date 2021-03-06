#' Getting islands in high res & correct long lats
#'
#' This function allows you to go from shp to df, and specify a projection
#' @param islandname The name of the island you are looking for
#' @param proj The name of the projection you would like the shapefile returned inCurrently either only "wgs84" or "nztm"
#' @keywords transform reproject map
#' @importFrom magrittr "%>%"
#' @importFrom rlang .data
#' @import sp dplyr broom
#' @export
#' @examples
#' isle <- find_my_island("codfish", proj = "nztm")
#' plot(isle)
#' isle@proj4string
#' # for wgs84
#' isle <- find_my_island("codfish", proj = "wgs84")
#' plot(isle)
#' isle@proj4string
#' # multiple islands
#' many <- find_my_island(c("auckland", "campbell"))
#' plot(many)


find_my_island <- function(islandname, proj = "wgs84"){

  wgs84 <- sp::CRS("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs ")
  nztm <- sp::CRS("+proj=tmerc +lat_0=0 +lon_0=173 +k=0.9996 +x_0=1600000 +y_0=10000000 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs ")


  tomatch <- tolower(paste(islandname,collapse="|"))


  sel <- detailed_nz_islands[apply(detailed_nz_islands@data, 1, function(row) length(grep(tomatch, tolower(row)))>0), ]

  matches <- sel@data[ c(1, 6) ]
  matches <- matches %>%
    dplyr::group_by(., name, grp_name) %>% dplyr::slice(1) %>% data.frame() %>% droplevels()

  if(nrow(matches) > 0){

    print(matches)
    print(paste(nrow(matches), " match(es) found. Site(s) found listed above",
                #paste(matches, collapse=", "),
                sep = ""))
  } else {
    stop("no matches found. please ensure spelling is correct. available islands are listed using: `detailed_nz_islands@data`")
  }

  if(!proj %in% c("wgs84", "nztm")) {
    stop("please choose either 'wgs84' or 'nztm' as the desired projection")
  }

  if(proj == "nztm"){
    selSP <- sp::spTransform(sel, nztm)

  }  else if(proj == "wgs84"){
    selSP <- sp::spTransform(sel, wgs84 )

  }
  return(selSP)


}
