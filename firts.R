# List all .shp files recursively from the base folder
base_dir <- "C:/Users/t7825/Downloads/hackolton-group2/Hackathon_2_D2A"

list.files(path = base_dir, pattern = "\\.shp$", recursive = TRUE, full.names = TRUE)

# Load libraries
library(sf)
library(ggplot2)

# Correct path — raw string, all on ONE line
shp_path <- r"(C:/Users/t7825/Downloads/hackolton-group2/Hackathon_2_D2A/2025_GEOM_TK/01_INST/Gesamtfla╠êche_gf/K4_polg20101231_gf/K4polg20101231gf_ch2007Poly.shp)"

# Load the shapefile
swiss_map <- sf::read_sf(shp_path)

# Plot the map
ggplot() +
  geom_sf(data = swiss_map, fill = "lightgreen", color = "black") +
  theme_minimal() +
  labs(title = "Switzerland Map (Polygons 2010)")




# Add population size to visualize city importance

ggplot() +
  geom_sf(data = swiss_map, fill = "white", color = "gray") +
  geom_sf(data = cities_sf, aes(size = population), color = "blue", alpha = 0.6) +
  scale_size_continuous(name = "Population") +
  theme_minimal() +
  labs(title = "Swiss Cities by Population")


ggplot() +
  geom_sf(data = swiss_map, fill = "white", color = "gray") +
  geom_sf(data = cities_sf, aes(color = admin_name), size = 2) +
  theme_minimal() +
  labs(title = "Swiss Cities Colored by Canton")

