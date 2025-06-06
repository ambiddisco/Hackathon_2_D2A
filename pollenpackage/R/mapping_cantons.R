#' plot_cantons is a function that plots cantons data
#'
#' @param canton_path a string value, defines path to canton data
#' @param lake_path a string value, defines path to lake data
#' @param value_df a tibble, determines the dataframeof values to plot
#' @param map_crs an integer value, determines the reference system of the
#' geographical data. Basic value is 2056.
#' @param value_colname a string value, determines the name of the column plotted
#' @param title a string value, determines the overall title of the plot
#'
#' @returns Nothing, directly plots a map of cantons
#' @import sf
#' @import ggplot2
#' @export dplyr
#'
#' @examples plot_cantons(canton_path = "path_to_cantons",
#'                       lake_path = "path_to_lake",
#'                       value_df = df,
#'                       value_colname = "avg",
#'                       title = "Map of Cantons") -> NONE

plot_cantons <- function(
    canton_path,
    lake_path = NULL,
    value_df,
    map_crs = 2056,
    value_colname = "avg",
    title = "Map"
) {

  cantons <- sf::st_read(canton_path, quiet = TRUE) |> sf::st_transform(map_crs)
  lakes <- if (!is.null(lake_path)) sf::st_read(lake_path, quiet = TRUE) |> sf::st_transform(map_crs) else NULL

  value_df <- value_df |>
    dplyr::rename(name = canton) |>
    dplyr::mutate(name = as.character(name))

  cantons <- dplyr::left_join(cantons, value_df, by = "name")

  p <- ggplot2::ggplot() +
    ggplot2::geom_sf(data = cantons, ggplot2::aes(fill = .data[[value_colname]]), color = "black", size = 0.5)

  if (!is.null(lakes)) {
    p <- p + ggplot2::geom_sf(data = lakes, fill = "lightblue", color = NA)
  }

  p <- p +
    scale_fill_viridis_c(option = "plasma", na.value = "grey90", name = value_colname)
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

