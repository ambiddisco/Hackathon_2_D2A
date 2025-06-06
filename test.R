library(pollenpackage)

#Changing the name in value_colname or point_color change the shown 

df <- read.csv("canton_pollen_aggregated.csv")

plot_cantons(
  value_df = df,
  value_colname = "avg",
  title = "Map by Canton"
)


plot_cantons(
  value_df = df,
  value_colname = "Oak",
  title = "Map by Canton"
)




file_name = "swiss_city_pollen_data.csv"
df = read.csv(file_name)

plot_map(
  title = "Map",
  points_df = df,
  point_color = "Birch",
  point_size = 2.5,
  heatmap = TRUE
)


plot_map(
  title = "Map",
  points_df = df,
  point_color = "avg",
  point_size = 2.5,
  heatmap = TRUE
)
