#' Swiss Cities Dataset
#'
#' This dataset includes 200 Swiss cities with their geographic coordinates and population.
#' 
#' @name SwissCities
#' @format A CSV file with the following columns:
#' \describe{
#'   \item{name}{City name (character)}
#'   \item{latitude}{Latitude in decimal degrees (numeric)}
#'   \item{longitude}{Longitude in decimal degrees (numeric)}
#'   \item{population}{City population (integer)}
#' }
#' @details The file is stored in `inst/extdata/SwissCities.csv` and accessed via the helper function [get_swiss_cities_path()].
#'
#' @source Provided as part of the Hackathon 2025 materials.
#'
#' @seealso [get_swiss_cities_path()]
#' @examples
#' if (requireNamespace("readr", quietly = TRUE)) {
#'   path <- get_swiss_cities_path()
#'   swiss_cities <- readr::read_csv(path)
#'   head(swiss_cities)
#' }
NULL