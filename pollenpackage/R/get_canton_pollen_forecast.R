#' get_canton_pollen_forecast returns a forecast of the pollen distribution of
#' eacch canton in a dataframe form
#'
#' @returns a dataframe containing pollen forecast per canton
#' @import httr2
#'
#' @examples get_canton_pollen_forecast() -> df
get_canton_pollen_forecast <- function(){
  # Impostare l'URL dell'API
  generic_API_url <- "https://pollen.googleapis.com/v1/forecast:lookup?key=AIzaSyC92T2AOV70myeLieFg8m2iQS4vaCUQRQg"

  # Creare il dataframe con le coordinate dei cantoni
  # Using the full canton names for grouping later
  swiss_cantons <- data.frame(
    canton = c(
      rep("Valais", 5),
      rep("Genève", 3),
      rep("Vaud", 6),
      rep("Neuchâtel", 4),
      rep("Jura", 8),
      rep("Solothurn", 6),
      rep("Basel-Landschaft", 7),
      rep("Luzern", 8),
      rep("Obwalden", 7),
      rep("Nidwalden", 6),
      rep("Tessin", 6),
      rep("Graubünden", 6),
      rep("Glarus", 3),
      rep("Appenzell Ausserrhoden", 6),
      rep("Schwyz", 2),
      rep("Zug", 2),
      rep("Schaffhausen", 2),
      rep("Thurgau", 4),
      rep("Aargau", 6),
      rep("Bern", 8),
      rep("Uri", 4),
      rep("Fribourg", 8),
      rep("St. Gallen", 5),
      rep("Appenzell Innerrhoden", 5),
      rep("Zürich", 7),
      rep("Basel-Stadt", 1)
    ),
    lat = c(
      46.0446218, 45.9166536, 46.5428957, 46.3665249, 46.2676035,
      46.1323763, 46.1412125, 46.3011591,
      46.4412487, 46.9158872, 46.4486226, 46.1984945, 46.4534613, 46.7756036,
      46.9157464, 46.9847783, 47.1240033, 47.0380800,
      47.4969757, 47.3192478, 47.1697991, 47.3562671, 47.3518523, 47.4367442, 47.3647242, 47.2884381,
      47.1890647, 47.1265625, 47.2670788, 47.3335530, 47.3676505, 47.4589548,
      47.4099854, 47.3666518, 47.5367160, 47.4708317, 47.4013076, 47.3732506, 47.5036587,
      46.9141473, 47.1005707, 46.7870258, 47.2502349, 47.2527194, 47.0279301, 47.0777274, 47.0468691,
      46.8308083, 46.7952221, 46.9067508, 46.7714998, 46.8276617, 46.9555229, 46.9155954,
      46.9755160, 46.9365985, 46.8663281, 46.9938784, 46.7856871, 46.9646777,
      45.8462751, 46.0941096, 46.3463719, 46.5220076, 46.2771274, 46.1528183,
      46.8392800, 46.6921736, 46.4682548, 46.7312471, 46.9044389, 46.5884242,
      47.0576009, 46.8621904, 46.9200407,
      46.9530808, 47.0889417, 47.2071140, 47.3394460, 47.4010052, 47.2595373,
      47.1584462, 47.0455854,
      47.1339202, 47.2030921,
      47.7488548, 47.6929477,
      47.4506976, 47.5375735, 47.6186880, 47.5439866,
      47.1865446, 47.2735160, 47.3296382, 47.4587898, 47.5095924, 47.3002523,
      46.4177984, 46.5488873, 46.7850384, 46.8177048, 46.7711450, 46.8449551, 47.1667063, 47.0128956,
      46.8219635, 46.6398242, 46.8017772, 46.8943735,
      46.9360076, 46.7864226, 46.8059296, 46.7023805, 46.6192580, 46.5291334, 46.6228595, 46.7395334,
      46.9533054, 47.1540757, 47.1876144, 47.3888464, 47.1159660,
      47.2545819, 47.3565969, 47.3077236, 47.3357044, 47.3064280,
      47.3048422, 47.2617546, 47.2260782, 47.5697154, 47.4857380, 47.4442882, 47.5170851,
      47.5741530
    ),
    lon = c(
      6.8858186, 7.8690379, 8.4023386, 7.5207129, 7.7523171,
      5.9560496, 6.1844710, 6.2433229,
      6.0909738, 6.7075657, 6.8978826, 7.0859698, 6.6397982, 6.8094762,
      6.5297301, 6.7339977, 6.8668389, 7.0432382,
      6.9974863, 7.5248850, 6.8572559, 6.8863817, 7.0532216, 7.1831116, 7.1902487, 7.2318465,
      7.3833312, 7.4584814, 7.5582377, 7.6497205, 7.9270923, 7.6516415,
      7.4618461, 7.8280184, 7.5361271, 7.8479060, 7.6704521, 7.7221164, 7.5649335,
      8.0160076, 7.9156558, 7.9947621, 7.9768072, 8.2664182, 8.4435420, 8.0912354, 8.2076708,
      8.4588112, 8.4466433, 8.1522460, 8.1675618, 8.3117840, 8.2822468, 8.3307167,
      8.3411685, 8.4616401, 8.4417761, 8.4044569, 8.3873335, 8.5424441,
      9.0435255, 8.9274496, 8.9693020, 8.6123720, 8.6506652, 8.7858045,
      9.5203721, 9.1847004, 9.8432167, 10.1319062, 10.4488278, 10.3632693,
      9.0778066, 9.0013109, 9.1582338,
      9.3273008, 9.4305624, 9.4620437, 9.1711918, 9.0332656, 8.9695612,
      8.7706715, 8.7383365,
      8.6171286, 8.5495959,
      8.6047298, 8.5199803,
      8.9744009, 9.3132530, 9.0823713, 8.9170123,
      8.3735418, 8.1341834, 8.3457860, 8.3234746, 8.0667194, 8.0647328,
      7.3758788, 8.1169096, 7.8523014, 7.6848203, 7.4426671, 7.7901001, 7.7698632, 7.1260480,
      8.5991382, 8.5542492, 8.5288095, 8.6679708,
      7.1586182, 7.0497815, 7.2544517, 7.2610078, 7.1826047, 7.0567098, 6.9413489, 7.0077634,
      9.3998764, 9.1634547, 9.4175239, 9.1010074, 9.2012889,
      9.4178506, 9.3691580, 9.3557183, 9.4404552, 9.4682820,
      8.9089693, 8.7478779, 8.8117250, 8.6890839, 8.4478934, 8.4278250, 8.6574700,
      7.6429092
    )
  )

  # Creare una lista di piante
  plants_list <- c("Hazel", "Ash", "Cottonwood", "Oak", "Pine", "Birch", "Olive", "Alder", "Grasses", "Ragweed", "Mugwort")

  # Initialize an empty list to store results for each point
  rows_list_points <- list()

  # Iterare su ogni riga del dataframe con le coordinate
  for (i in 1:nrow(swiss_cantons)) {
    current_lat <- swiss_cantons$lat[i]
    current_lon <- swiss_cantons$lon[i]
    current_canton_name <- swiss_cantons$canton[i] # Get the canton name

    api_url <- paste0(generic_API_url, "&location.longitude=", current_lon, "&location.latitude=", current_lat, "&days=1")

    # --- API Request and Error Handling ---
    response_data <- tryCatch({
      req <- httr2::request(api_url)
      resp <- req_perform(req)
      resp_body_json(resp)
    }, error = function(e) {
      warning(paste("API request failed for point in", current_canton_name, "at lat/lon:", current_lat, "/", current_lon, ":", e$message))
      NULL # Return NULL on error
    })

    # Check if API request was successful and contains plant data
    if (is.null(response_data) || is.null(response_data$dailyInfo[[1]]$plantInfo)) {
      warning(paste("No valid plant data or API response for point in", current_canton_name, "at lat/lon:", current_lat, "/", current_lon, ". Skipping this point."))
      next # Skip to the next iteration of the loop
    }

    plant_info <- response_data$dailyInfo[[1]]$plantInfo

    # --- Prepare current row for data frame ---
    current_row <- data.frame(
      canton = current_canton_name, # Store the canton name
      lon = current_lon,
      lat = current_lat,
      avg = 0, # Initialize avg to 0, will be updated if valid_values exist
      stringsAsFactors = FALSE
    )

    # Initialize plant columns to 0
    for (plant_col in plants_list) {
      current_row[[plant_col]] <- 0
    }

    # Extract plant values efficiently
    # Create a named vector for easy lookup
    plant_values_map <- setNames(
      sapply(plant_info, function(x) ifelse(is.null(x$indexInfo$value), 0, x$indexInfo$value)),
      sapply(plant_info, function(x) x$displayName)
    )

    for (plant_name in plants_list) {
      if (plant_name %in% names(plant_values_map)) {
        current_row[[plant_name]] <- plant_values_map[[plant_name]]
      }
    }

    # Calculate average for non-zero plant values
    valid_values <- unlist(current_row[plants_list])
    valid_values <- valid_values[valid_values != 0]

    if (length(valid_values) > 0) {
      current_row$avg <- mean(valid_values)
    }

    # Add the processed row to the list
    rows_list_points[[length(rows_list_points) + 1]] <- current_row
  }

  # Combine all point data into a single data frame
  if (length(rows_list_points) > 0) {
    df_points <- do.call(rbind, rows_list_points)
  } else {
    # If no data was processed, create an empty data frame with correct columns
    df_points <- data.frame(
      canton = character(),
      lon = numeric(),
      lat = numeric(),
      avg = numeric(), # Ensure 'avg' is explicitly here
      stringsAsFactors = FALSE
    )
    for (plant_col in plants_list) {
      df_points[[plant_col]] <- numeric()
    }
  }

  # --- Aggregate data by canton ---
  # Now, group by canton and calculate the mean for each numeric column

  # If df_points is empty, the aggregation will result in an empty data frame, which is fine.
  if (nrow(df_points) > 0) {
    df_cantons_aggregated <- df_points %>%
      group_by(canton) %>%
      summarise(
        across(
          c(avg, all_of(plants_list)), # Apply mean to 'avg' and all plant columns
          ~ mean(., na.rm = TRUE)
        ),
        .groups = 'drop' # Remove grouping
      )
  } else {
    df_cantons_aggregated <- data.frame(
      canton = character(),
      avg = numeric(), # Ensure 'avg' is explicitly here
      stringsAsFactors = FALSE
    )
    for (plant_col in plants_list) {
      df_cantons_aggregated[[plant_col]] <- numeric()
    }
  }
  return(df_cantons_aggregated) # Corrected: return df_cantons_aggregated
}
