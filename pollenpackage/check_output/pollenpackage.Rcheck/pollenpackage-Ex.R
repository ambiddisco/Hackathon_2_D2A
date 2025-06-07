pkgname <- "pollenpackage"
source(file.path(R.home("share"), "R", "examples-header.R"))
options(warn = 1)
options(pager = "console")
base::assign(".ExTimings", "pollenpackage-Ex.timings", pos = 'CheckExEnv')
base::cat("name\tuser\tsystem\telapsed\n", file=base::get(".ExTimings", pos = 'CheckExEnv'))
base::assign(".format_ptime",
function(x) {
  if(!is.na(x[4L])) x[1L] <- x[1L] + x[4L]
  if(!is.na(x[5L])) x[2L] <- x[2L] + x[5L]
  options(OutDec = '.')
  format(x[1L:3L], digits = 7L)
},
pos = 'CheckExEnv')

### * </HEADER>
library('pollenpackage')

base::assign(".oldSearch", base::search(), pos = 'CheckExEnv')
base::assign(".old_wd", base::getwd(), pos = 'CheckExEnv')
cleanEx()
nameEx("SwissCities")
### * SwissCities

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: SwissCities
### Title: Swiss Cities Dataset
### Aliases: SwissCities

### ** Examples

if (requireNamespace("readr", quietly = TRUE)) {
  path <- get_swiss_cities_path()
  swiss_cities <- readr::read_csv(path)
  head(swiss_cities)
}



base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("SwissCities", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("get_canton_pollen_forecast")
### * get_canton_pollen_forecast

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: get_canton_pollen_forecast
### Title: get_canton_pollen_forecast returns a forecast of the pollen
###   distribution of eacch canton in a dataframe form
### Aliases: get_canton_pollen_forecast

### ** Examples

get_canton_pollen_forecast() -> df



base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("get_canton_pollen_forecast", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("get_map_path")
### * get_map_path

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: get_map_path
### Title: Get full path to a shapefile in extdata/maps/
### Aliases: get_map_path

### ** Examples

get_map_path("see")
get_map_path("kanton")
get_map_path("berggebiete")



base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("get_map_path", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("get_pollen_forecast")
### * get_pollen_forecast

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: get_pollen_forecast
### Title: get_pollen_forecast: fetches information from api and loads the
###   data.
### Aliases: get_pollen_forecast

### ** Examples

get_pollen_forecast() -> pollen_df



base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("get_pollen_forecast", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("get_swiss_cities_path")
### * get_swiss_cities_path

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: get_swiss_cities_path
### Title: Get full path to SwissCities.csv
### Aliases: get_swiss_cities_path

### ** Examples

## Not run: swiss_cities <- read.csv(get_swiss_cities_path())



base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("get_swiss_cities_path", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("plot_cantons")
### * plot_cantons

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: plot_cantons
### Title: Plot Cantons with Value Overlay
### Aliases: plot_cantons

### ** Examples

value_df <- tibble::tibble(
  canton = c("Zürich", "Bern", "Luzern", "Uri", "Schwyz"),
  avg = c(78.5, 82.3, 80.1, 75.0, 79.4)
)
plot_cantons(value_df, value_colname = "avg", title = "Life Expectancy in")



base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("plot_cantons", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
### * <FOOTER>
###
cleanEx()
options(digits = 7L)
base::cat("Time elapsed: ", proc.time() - base::get("ptime", pos = 'CheckExEnv'),"\n")
grDevices::dev.off()
###
### Local variables: ***
### mode: outline-minor ***
### outline-regexp: "\\(> \\)?### [*]+" ***
### End: ***
quit('no')
