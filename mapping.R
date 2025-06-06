library(sf)
library(ggplot2)

plot_map <- function(
    canton_path,
    mountain_path,
    lake_path = NULL,
    points_df = NULL,
    points_crs = 4326,
    map_crs = 2056,
    base_fill = "darkseagreen3",
    mountain_fill = "bisque3",
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
    if ("value" %in% colnames(points_df)) {
      p <- p + geom_sf(data = points_sf, aes(color = value), size = point_size) +
        scale_color_viridis_c(option = "plasma")
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
