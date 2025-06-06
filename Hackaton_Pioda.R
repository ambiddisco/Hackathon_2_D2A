library(httr2)
library(tidyverse)

generic_API_url <- "https://pollen.googleapis.com/v1/forecast:lookup?key=AIzaSyC92T2AOV70myeLieFg8m2iQS4vaCUQRQg&location.longitude=8.5411&location.latitude=47.3744&days=1"

swiss_cities <- read.csv('SwissCities.csv')

swiss_cities <- swiss_cities[, c('city_ascii', 'lat', 'lng', 'admin_name')]


req <- request(generic_API_url)

resp <- req_perform(req)

resp |> resp_content_type()

resp |> resp_status_desc()

a <- resp |> resp_body_json()

print(a)


