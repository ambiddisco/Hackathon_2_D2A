library(httr2)

#' get_pollen_forecast: fetches information from api and loads the data.
#' @importFrom httr2 request req_perform resp_body_json
#'
#' @returns a dataframe containing all information about pollen forecast.
#' @export
#'
#' @examples get_pollen_forecast() -> pollen_df
get_pollen_forecast <- function(){
  # Set the base API URL
  generic_API_url <- "https://pollen.googleapis.com/v1/forecast:lookup?key=AIzaSyC92T2AOV70myeLieFg8m2iQS4vaCUQRQg"
  
  # Load city data from CSV
  swiss_cities <- read.csv(get_swiss_cities_path())
  swiss_cities <- swiss_cities[, c('city_ascii', 'lat', 'lng', 'admin_name')]
  
  # Unified list of plants
  plants_list <- c("Hazel", "Ash", "Cottonwood", "Oak", "Pine", "Birch", "Olive", "Alder", "Grasses", "Ragweed", "Mugwort")
  
  # Create an empty dataframe with the desired structure
  df <- data.frame(city = character(),
                   lon = numeric(),
                   lat = numeric(),
                   avg = numeric(),
                   Hazel = numeric(),
                   Ash = numeric(),
                   Cottonwood = numeric(),
                   Oak = numeric(),
                   Pine = numeric(),
                   Birch = numeric(),
                   Olive = numeric(),
                   Alder = numeric(),
                   Grasses = numeric(),
                   Ragweed = numeric(),
                   Mugwort = numeric(),
                   stringsAsFactors = FALSE)
  
  # Iterate through the cities in the dataframe
  for (count in 1:nrow(swiss_cities)) {
    # Retrieve city information (latitude, longitude, and city name)
    lat <- swiss_cities$lat[count]
    lng <- swiss_cities$lng[count]
    city <- swiss_cities$city_ascii[count]
    
    # Compose the API URL for this city
    api_url <- paste0(generic_API_url, "&location.longitude=", lng, "&location.latitude=", lat, "&days=1")
    
    # Perform the HTTP request
    req <- httr2::request(api_url)
    resp <- httr2::req_perform(req)
    
    # Extract the JSON response
    json <- resp |> httr2::resp_body_json()
    
    # Check if plant data is available in the response
    if (!is.null(json$dailyInfo[[1]]$plantInfo)) {
      plant_info <- json$dailyInfo[[1]]$plantInfo
    } else {
      print("No plant data available.")
      stop()
    }
    
    # Initialize the row for the dataframe with default values
    row <- data.frame(
      city = city,
      lon = lng,
      lat = lat,
      avg = NA,
      Hazel = 0, Ash = 0, Cottonwood = 0, Oak = 0, Pine = 0,
      Birch = 0, Olive = 0, Alder = 0, Grasses = 0, Ragweed = 0, Mugwort = 0
    )
    
    # Populate the dataframe with the "value" for each plant
    for (plant in plants_list) {
      plant_data <- sapply(plant_info, function(x) x$displayName == plant)
      
      if (any(plant_data)) {
        value <- plant_info[[which(plant_data)[1]]]$indexInfo$value
        
        if (!is.null(value) && length(value) > 0) {
          row[[plant]] <- value
        } else {
          row[[plant]] <- 0
        }
        
      } else {
        row[[plant]] <- 0
      }
    }
    
    # Calculate the average of the non-zero values
    valid_values <- unlist(row[plants_list])
    valid_values <- valid_values[valid_values != 0]
    
    if (length(valid_values) > 0) {
      row$avg <- mean(valid_values)
    } else {
      row$avg <- 0
    }
    
    # Add the row to the dataframe
    df <- rbind(df, row)
  }
  return (df)
}
