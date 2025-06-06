#' Get full path to a shapefile in extdata/maps/
#'
#' @param type The name of the map folder, e.g. "see", "kanton", "berggebiete"
#' @param filename The shapefile name (default for standard naming)
#'
#' @return Full path to the requested shapefile
#' @export
#'
#' @examples
#' get_map_path("see")
#' get_map_path("kanton")
#' get_map_path("berggebiete")
get_map_path <- function(type = c("see", "kanton", "berggebiete"),
                         filename = NULL) {
  type <- match.arg(type)
  
  if (is.null(filename)) {
    filename <- switch(
      type,
      see = "k4seenyyyymmdd11_ch2007Poly.shp",
      kanton = "k4seenyyyymmdd22_ch2007Poly.shp",
      berggebiete = "k4seenyyyymmdd33_ch2007Poly.shp",  # <- adjust as needed
      stop("Unknown map type")
    )
  }

  system.file("extdata/maps", type, filename, package = "yourpackagename", mustWork = TRUE)
}
