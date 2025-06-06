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
  
  cantons <- st_read(canton_path, quiet = TRUE) |> st_transform(map_crs)
  mountains <- st_read(mountain_path, quiet = TRUE) |> st_transform(map_crs)
  lakes <- if (!is.null(lake_path)) st_read(lake_path, quiet = TRUE) |> st_transform(map_crs) else NULL
  
  p <- ggplot() +
    geom_sf(data = cantons, fill = base_fill, color = NA) +
    geom_sf(data = mountains, fill = mountain_fill, color = NA, alpha = 1)
  
  if (!is.null(lakes)) {
    p <- p + geom_sf(data = lakes, fill = lake_fill, color = NA, alpha = 1)
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
          geom_raster(data = interp_df, aes(x = x, y = y, fill = value, alpha = value)) +
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
      p <- p + geom_sf(data = points_sf, color = point_color, size = point_size)
    }
    
    if (!heatmap && show_labels && "label" %in% colnames(points_df)) {
      coords <- st_coordinates(points_sf)
      points_sf$X <- coords[,1]
      points_sf$Y <- coords[,2]
      p <- p + geom_text(data = points_sf, aes(x = X, y = Y, label = label),
                         size = 3, color = "black", nudge_y = 1000)
    }
  }
  
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