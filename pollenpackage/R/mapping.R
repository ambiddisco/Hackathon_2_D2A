library(sf)
library(ggplot2)

#' Title
#'
#' @param canton_path the path to the file containing canton data
#' @param mountain_path the path to the file containing mountain data
#' @param lake_path the path to the file containing lake data
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
#' @examples
plot_map <- function(
    canton_path,
    mountain_path,
    lake_path = NULL,
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

  cantons <- st_read(canton_path, quiet = TRUE) |> st_transform(map_crs)
  mountains <- st_read(mountain_path, quiet = TRUE) |> st_transform(map_crs)
  lakes <- if (!is.null(lake_path)) st_read(lake_path, quiet = TRUE) |> st_transform(map_crs) else NULL

  #BASE COL
  p <- ggplot() +
    geom_sf(data = cantons, fill = base_fill, color = NA) +
    geom_sf(data = mountains, fill = mountain_fill, color = NA, alpha = 1)

  #LAKES
  if (!is.null(lakes)) {
    p <- p + geom_sf(data = lakes, fill = lake_fill, color = NA, alpha = 1)
  }
  #BORDERS
  p <- p + geom_sf(data = cantons, fill = NA, color = border_color, size = 0.5)

  #PLOT POINTS
  if (!is.null(points_df)) {
    points_sf <- st_as_sf(points_df, coords = c("lon", "lat"), crs = points_crs) |>
      st_transform(map_crs)
    if (!is.null(point_color) && point_color %in% colnames(points_df)) {
      p <- p + geom_sf(data = points_sf, aes(color = .data[[point_color]]), size = point_size) +
        scale_color_viridis_c(option = "plasma", name = point_color)
    } else {
      p <- p + geom_sf(data = points_sf, color = point_color, size = point_size)
    }
    if (show_labels && "label" %in% colnames(points_df)) {
      coords <- st_coordinates(points_sf)
      points_sf$X <- coords[,1]
      points_sf$Y <- coords[,2]
      p <- p + geom_text(data = points_sf, aes(x = X, y = Y, label = label),
                         size = 3, color = "black", nudge_y = 1000)
    }
  }

  #PLOTTING AND STYLING
  p <- p +
    ggtitle(title) +
    theme_minimal() +
    theme(
      plot.background = element_rect(fill = "white", color = NA),
      panel.background = element_rect(fill = "white", color = NA),
      axis.text = element_blank(),
      axis.ticks = element_blank(),
      panel.grid = element_blank()
    )

  print(p)
}



plot_map(
  canton_path = "kanton/K4kant20220101gf_ch2007Poly.shp",
  mountain_path = "berggebiete/K4_bgbr20210101gf_ch2007Poly.shp",
  lake_path = "see/k4seenyyyymmdd11_ch2007Poly.shp",
  title = "Map"
)
