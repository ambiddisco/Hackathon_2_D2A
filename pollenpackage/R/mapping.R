library(sf)
library(ggplot2)

#' Title
#'
#' @param canton_type the path to the file containing canton data
#' @param mountain_type the path to the file containing mountain data
#' @param lake_type the path to the file containing lake data
#' @param points_df a tibble or dataframe, contains a list of all points to be
#' plotted on the graph. Basic value is NONE.
#' @param points_crs an integer value, crs stands for coordinate reference system,
#' specifies latitude and longitude in degrees of a given point.
#' Basic value is 4326, same as standard GPS value.
#' @param map_crs an integer value, crs stands for coordinate reference system,
#' specifies the crs for countries and larger areas.
#' Basic value is 2056.
#' @param base_fill a string value, the string representing the colour of the
#' base map on the graph
#' @param mountain_fill a string value, the string representing the colour of
#' the mountain representation on the graph
#' @param lake_fill a string value, the string representing the colour of the
#' lake representation on the graph
#' @param border_color a string value, the string representing the colour of the
#' graph border
#' @param point_color a string value, the string representing the colour of the
#' points in the graph
#' @param point_size an integer value, size of the points on the graph
#' @param show_labels a boolean value, if to show the labels of the graph
#' @param title the title of the graph
#'
#' @returns Nothing, plots graph directly
#' @export
#'
plot_map <- function(
    canton_type = "kanton",
    mountain_type = "berggebiete",
    lake_type = NULL,
    points_df = NULL,
    points_crs = 4326,
    map_crs = 2056,
    base_fill = rgb(176/256, 227/256, 170/256),
    mountain_fill = "antiquewhite2",
    lake_fill = "lightblue",
    border_color = "black",
    point_color = "red",
    point_size = 2,
    show_labels = TRUE,
    title = "Map"
) {
  # Load spatial data using helper
  canton_path <- get_map_path(canton_type)
  mountain_path <- get_map_path(mountain_type)
  lake_path <- if (!is.null(lake_type)) get_map_path(lake_type) else NULL
  
  cantons <- sf::st_read(canton_path, quiet = TRUE) |> sf::st_transform(map_crs)
  mountains <- sf::st_read(mountain_path, quiet = TRUE) |> sf::st_transform(map_crs)
  lakes <- if (!is.null(lake_path)) sf::st_read(lake_path, quiet = TRUE) |> sf::st_transform(map_crs) else NULL
  
  # Base map
  p <- ggplot2::ggplot() +
    ggplot2::geom_sf(data = cantons, fill = base_fill, color = NA) +
    ggplot2::geom_sf(data = mountains, fill = mountain_fill, color = NA, alpha = 1)
  
  # Lakes
  if (!is.null(lakes)) {
    p <- p + ggplot2::geom_sf(data = lakes, fill = lake_fill, color = NA, alpha = 1)
  }
  
  # Borders
  p <- p + ggplot2::geom_sf(data = cantons, fill = NA, color = border_color, size = 0.5)
  
  # Points
  if (!is.null(points_df)) {
    points_sf <- sf::st_as_sf(points_df, coords = c("lon", "lat"), crs = points_crs) |> sf::st_transform(map_crs)
    
    if (!is.null(point_color) && point_color %in% colnames(points_df)) {
      p <- p + ggplot2::geom_sf(data = points_sf, ggplot2::aes(color = .data[[point_color]]), size = point_size) +
        ggplot2::scale_color_viridis_c(option = "plasma", name = point_color)
    } else {
      p <- p + ggplot2::geom_sf(data = points_sf, color = point_color, size = point_size)
    }
    
    if (show_labels && "label" %in% colnames(points_df)) {
      coords <- sf::st_coordinates(points_sf)
      points_sf$X <- coords[,1]
      points_sf$Y <- coords[,2]
      p <- p + ggplot2::geom_text(data = points_sf, ggplot2::aes(x = X, y = Y, label = label),
                                  size = 3, color = "black", nudge_y = 1000)
    }
  }
  
  # Styling
  p <- p +
    ggplot2::ggtitle(title) +
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