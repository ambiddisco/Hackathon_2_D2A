library(ggplot2)
library(sf)
library(dplyr)
library(tidyr)
library(viridis)

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




df <- read.csv("canton_pollen_aggregated.csv")

plot_cantons(
  canton_path = "kanton/K4kant20220101gf_ch2007Poly.shp",
  lake_path = "see/k4seenyyyymmdd11_ch2007Poly.shp",
  value_df = df,
  value_colname = "avg",
  title = "Map by Canton"
)
