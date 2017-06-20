#' Getting islands in high res & correct long lats
#'
#' This function allows you to go from shp to df, and specify a projection
#' @param islandname The name of the island you are looking for
#' @param proj The name of the projection you would like the shapefile returned inCurrently either only "wgs84" or "nztm"
#' @keywords transform reproject map
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

  wgs84 <- CRS("+init=epsg:3857 +proj=longlat ")


  tomatch <- tolower(paste(islandname,collapse="|"))


  sel <- detailed_nz_islands[apply(detailed_nz_islands@data, 1, function(row) length(grep(tomatch, tolower(row)))>0), ]

  matches <- sel@data[ c(1, 6) ]
  matches <- matches %>% group_by(name, grp_name) %>% slice(1) %>% data.frame() %>% droplevels()

  if(nrow(matches) > 0){

    print(matches)
    print(paste(nrow(matches), " match(es) found. Site(s) found listed above",
                #paste(matches, collapse=", "),
                sep = ""))
  } else {
    stop("no matches found. please ensure spelling is correct. available islands are listed using: `detailed_nz_islands@data`")
  }

  if(proj == "nztm"){
    return(sel)
  }  else if(proj == "wgs84"){
    selSP <- spTransform(sel, wgs84 )
    return(selSP)
  } else{
    stop("please choose either 'wgs84' or 'nztm' as the desired projection")
  }

}
