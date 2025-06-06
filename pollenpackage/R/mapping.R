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
#' @param heatmap a boolean value, indicates if to include a heatmap of the data
#'
#' @returns Nothing, plots graph directly
#' @export
plot_map <- function(
    canton_path,
    mountain_path,
    lake_path = NULL,
    points_df = NULL,
    points_crs = 4326,
    map_crs = 2056,
    base_fill = rgb(217/256, 252/256, 221/256),
    mountain_fill = rgb(252/256, 244/256, 217/256),
    lake_fill = "lightblue",
    border_color = "black",
    point_color = "red",
    point_size = 2,
    show_labels = TRUE,
    title = "Map",
    heatmap = FALSE
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
  p <- p + geom_sf(data = cantons, fill = NA, color = border_color, size = 0.5)

  if (!is.null(points_df)) {
    points_sf <- st_as_sf(points_df, coords = c("lon", "lat"), crs = points_crs) |>
      st_transform(map_crs)

    if (!is.null(point_color) && point_color %in% colnames(points_df)) {
      if (heatmap) {
        # HEATMAP MODE
        coords <- st_coordinates(points_sf)
        values <- points_sf[[point_color]]
        sp_points <- as(points_sf, "Spatial")

        bbox <- st_bbox(cantons)
        grd <- raster::raster(
          xmn = bbox["xmin"], xmx = bbox["xmax"],
          ymn = bbox["ymin"], ymx = bbox["ymax"],
          resolution = 500,
          crs = crs(sp_points)
        )
        projection(grd) <- crs(sp_points)
        grd <- as(grd, "SpatialPixels")

        gstat_model <- gstat::gstat(formula = as.formula(paste(point_color, "~ 1")), data = sp_points, nmax = 7, set = list(idp = 2.0))
        interp <- predict(gstat_model, newdata = grd)
        interp_r <- raster::rasterFromXYZ(as.data.frame(interp)[, c("x", "y", "var1.pred")])

        interp_df <- as.data.frame(rasterToPoints(interp_r))
        colnames(interp_df) <- c("x", "y", "value")

        p <- p +
          geom_raster(data = interp_df, aes(x = x, y = y, fill = value, alpha = pmin(pmax(value, 0), 3))) +
          scale_fill_gradientn(
            colours = c(NA, "blue", "orange", "red"),
            na.value = NA,
            name = point_color
          ) +
          scale_alpha_continuous(range = c(0, 1), guide = "none")

      } else {
        # POINT MODE
        p <- p + geom_sf(data = points_sf, aes(color = .data[[point_color]]), size = point_size) +
          scale_color_viridis_c(option = "plasma", name = point_color)
      }
    } else {
      p <- p + ggplot2::geom_sf(data = points_sf, color = point_color, size = point_size)
    }

    if (!heatmap && show_labels && "label" %in% colnames(points_df)) {
      coords <- st_coordinates(points_sf)
      points_sf$X <- coords[,1]
      points_sf$Y <- coords[,2]
      p <- p + ggplot2::geom_text(data = points_sf, ggplot2::aes(x = X, y = Y, label = label),
                                  size = 3, color = "black", nudge_y = 1000)
    }
  }

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



#TESTING
file_name = "swiss_city_pollen_data.csv"
df = read.csv(file_name)


plot_map(
  canton_path = "kanton/K4kant20220101gf_ch2007Poly.shp",
  mountain_path = "berggebiete/K4_bgbr20210101gf_ch2007Poly.shp",
  lake_path = "see/k4seenyyyymmdd11_ch2007Poly.shp",
  title = "Map",
  points_df = df,
  point_color = "Birch",
  point_size = 2.5,
  heatmap = TRUE
)
