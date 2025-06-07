#' Get full path to SwissCities.csv
#'
#' This function returns the full path to the SwissCities.csv file
#' located in inst/extdata/.
#'
#' @return A string with the full path to SwissCities.csv
#' @export
#'
#' @examples
#' \dontrun{swiss_cities <- read.csv(get_swiss_cities_path())}
get_swiss_cities_path <- function() {
  system.file("extdata", "SwissCities.csv", package = "pollenpackage", mustWork = TRUE)
}
