library(httr2)
library(tidyverse)

# Impostare l'API URL di base
generic_API_url <- "https://pollen.googleapis.com/v1/forecast:lookup?key=AIzaSyC92T2AOV70myeLieFg8m2iQS4vaCUQRQg"

# Caricare i dati delle città dalla CSV
swiss_cities <- read.csv('SwissCities.csv')
swiss_cities <- swiss_cities[, c('city_ascii', 'lat', 'lng', 'admin_name')]

# Lista unificata delle piante
plants_list <- c("Hazel", "Ash", "Cottonwood", "Oak", "Pine", "Birch", "Olive", "Alder", "Grasses", "Ragweed", "Mugwort")

# Creare un dataframe vuoto con la struttura desiderata
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

counts = c(1,2,3)

# Iterare attraverso le città nel dataframe
for (count in counts) {
  # Prelevare le informazioni della città
  lat <- swiss_cities$lat[count]
  lng <- swiss_cities$lng[count]
  city <- swiss_cities$city_ascii[count]

  # Comporre l'URL della richiesta API per questa città
  api_url <- paste0(generic_API_url, "&location.longitude=", lng, "&location.latitude=", lat, "&days=1")

  # Effettuare la richiesta HTTP
  req <- request(api_url)
  resp <- req_perform(req)

  # Estrarre la risposta JSON
  json <- resp |> resp_body_json()

  # Verifica se i dati della pianta sono presenti nella risposta
  if (!is.null(json$dailyInfo[[1]]$plantInfo)) {
    plant_info <- json$dailyInfo[[1]]$plantInfo
  } else {
    print("No plant data available.")
    stop()
  }

  # Inizializzare la riga per il dataframe con valori di default
  row <- data.frame(
    city = city,
    lon = lng,
    lat = lat,
    avg = NA,  # Questo verrà calcolato più tardi
    Hazel = 0, Ash = 0, Cottonwood = 0, Oak = 0, Pine = 0,
    Birch = 0, Olive = 0, Alder = 0, Grasses = 0, Ragweed = 0, Mugwort = 0
  )

  # Popolare il dataframe con i valori "value" delle piante
  for (plant in plants_list) {
    # Verificare se la pianta è presente nella risposta
    plant_data <- sapply(plant_info, function(x) x$displayName == plant)

    if (any(plant_data)) {
      # Se la pianta è presente, salvare il valore "value"
      value <- plant_info[[which(plant_data)[1]]]$indexInfo$value

      # Controlla se 'value' è presente e assegnalo, altrimenti metti 0
      if (!is.null(value) && length(value) > 0) {
        row[[plant]] <- value
      } else {
        row[[plant]] <- 0
      }

    } else {
      # Se la pianta non è presente, settare il valore a 0
      row[[plant]] <- 0
    }
  }

  # Calcolare la media sui valori diversi da zero
  valid_values <- unlist(row[plants_list])  # Escludiamo 'city', 'lon', 'lat', 'avg'
  valid_values <- valid_values[valid_values != 0]  # Rimuovere i valori pari a zero
  if (length(valid_values) > 0) {
    row$avg <- mean(valid_values)  # Calcolare la media
  } else {
    row$avg <- 0  # Se non ci sono valori validi, la media è 0
  }

  # Aggiungere la riga al dataframe
  df <- rbind(df, row)
}

# Visualizzare il dataframe risultante (prima riga)
print(df)
