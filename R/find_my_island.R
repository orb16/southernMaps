#' Getting islands in high res & correct long lats
#'
#' This function allows you to go from shp to df, and specify a projection
#' @param islandname The name of the island you are looking for
#' @param proj The name of the projection you would like the shapefile returned inCurrently either only "wgs84" or "nztm"
#' @keywords transform reproject map
#' @importFrom magrittr "%>%"
#' @importFrom rlang .data
#' @import sf dplyr broom
#' @export
#' @examples
#' isle <- find_my_island("codfish", proj = "nztm")
#' plot(isle)
#' st_crs(isle)
#' # for wgs84
#' isle <- find_my_island("codfish", proj = "wgs84")
#' plot(isle)
#' isle
#' # multiple islands
#' many <- find_my_island(c("auckland", "campbell"))
#' plot(many)


find_my_island <- function(islandname, proj = "wgs84"){

  wgs84 <- st_crs(4326) 
  nztm <- st_crs(2193) 

  tomatch <- tolower(paste(islandname,collapse="|"))

  
  sel <- detailed_nz_islands %>%
    filter(grepl(tomatch, tolower(name)) |
             grepl(tomatch, tolower(macronated)) |
             grepl(tomatch, tolower(grp_macron))|
             grepl(tomatch, tolower(grp_ascii)) |
             grepl(tomatch, tolower(grp_name)) |
             grepl(tomatch, tolower(name_ascii)))


  matches <- sel %>%
    dplyr::select(name, grp_name) %>%
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
    selSP <- sf::st_transform(sel, nztm)

  }  else if(proj == "wgs84"){
    selSP <-  sf::st_transform(sel, wgs84 )

  }
  return(selSP)


}
