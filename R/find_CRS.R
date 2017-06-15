#' This function allows you to go from shp to df, and specify a projection
#' @param epsg the epsg name - in character
#' @param search Search term - e.g. "New Zealand"
#' @keywords epsg
#' @export
#' @examples


find_CRS <- function(epsg = NULL, search = NULL){

  if (!requireNamespace("sp", quietly = TRUE)) {
    stop("the SP pkg needed for this function to work. Please install it.",
         call. = FALSE)
  }

  if(is.null(epsg) & is.null(search)){
    stop("Please specify either epsg or search term")
  }


  if(!is.null(epsg) & !is.null(search)){
    stop("Please specify either epsg or search term, not both")
  }

  if(!is.null(epsg)){
    tab <- epsg_table[grep(paste("^", epsg, "$", sep = ""), epsg_table$code), ]
    if(nrow(tab) == 1){
      myCRS <- sp::CRS(tab[ , 3])
      return(myCRS)
    } else {stop("projection not found")}
  }


  if(!is.null(search)){
    tab <- epsg_table[grep(search, epsg_table$note), ]
    if(nrow(tab) == 1){
      print(paste("CRS for EPSG", tab[ , 1], "found", sep = " "))
      myCRS <- sp::CRS(tab[ , 3])
      return(myCRS)
    } else if(nrow(tab > 1)){

      print(tab)
      warning("Please select which CRS you are after and search using the EPSG")
    }
      else{stop("projection not found")}
  }



}
