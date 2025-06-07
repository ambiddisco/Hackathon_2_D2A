#' Plot Cantons with Value Overlay
#'
#' @param value_df A tibble with a 'canton' column and one value column to visualize
#' @param map_crs Integer CRS code (default is 2056 for LV95)
#' @param value_colname Name of the value column to plot
#' @param title Title of the plot
#'
#' @return Nothing, prints a map
#' @import sf
#' @import dplyr
#' @import ggplot2
#' @export
#'
#' @examples
#' value_df <- tibble::tibble(
#'   canton = c("Zürich", "Bern", "Luzern", "Uri", "Schwyz"),
#'   avg = c(78.5, 82.3, 80.1, 75.0, 79.4)
#' )
#' plot_cantons(value_df, value_colname = "avg", title = "Life Expectancy in")
plot_cantons <- function(
    value_df,
    map_crs = 2056,
    value_colname = "avg",
    title = "Map"
) {
  # Load canton and lake shapefiles
  cantons <- sf::st_read(get_map_path("kanton"), quiet = TRUE) |>
    sf::st_transform(map_crs)
  
  lakes <- sf::st_read(get_map_path("see"), quiet = TRUE) |>
    sf::st_transform(map_crs)
  
  # Prepare value data
  value_df <- value_df |>
    dplyr::rename(name = canton) |>
    dplyr::mutate(name = as.character(name))
  
  # Merge values into canton shapes
  cantons <- dplyr::left_join(cantons, value_df, by = "name")
  
  # Build plot
  p <- ggplot2::ggplot() +
    ggplot2::geom_sf(data = cantons, ggplot2::aes(fill = .data[[value_colname]]), color = "black", size = 0.5) +
    ggplot2::geom_sf(data = lakes, fill = "lightblue", color = NA) +
    ggplot2::scale_fill_viridis_c(option = "plasma", na.value = "grey90", name = value_colname) +
    ggplot2::ggtitle(paste(title, value_colname)) +
    ggplot2::theme_minimal() +
    ggplot2::theme(
      plot.background = ggplot2::element_rect(fill = "white", color = NA),
      panel.background = ggplot2::element_rect(fill = "white", color = NA),
      axis.text = ggplot2::element_blank(),
      axis.ticks = ggplot2::element_blank(),
      panel.grid = ggplot2::element_blank()
    )
  
  print(p)
}
