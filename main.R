library(pollenpackage)

#Changing the name in value_colname or point_color change the shown data (avg is average between all polens, Oak is oak, birch, etc...)

df <- get_canton_pollen_forecast()

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




points_df = get_pollen_forecast()
points_df
plot_map(
  title = "Map",
  points_df = points_df,
  point_color = "Birch",
  point_size = 2.5,
  heatmap = TRUE
)


plot_map(
  title = "Map",
  points_df = points_df,
  point_color = "avg",
  point_size = 2.5,
  heatmap = TRUE
)
