## code to prepare `city_data` dataset goes here

usethis::use_data("city_data")

library(rtweet)
library(data.table)
download.file(
  "http://download.geonames.org/export/dump/cities500.zip",
  tmp <- tempfile(fileext = ".zip")
)
unzip(tmp, exdir = dir <- tempdir())
d <- data.table::fread(
  list.files(dir, pattern = "cities500", full.names = TRUE)
)

## drop these columns
d[, c("V4", "V7", "V8", "V10", "V12", "V13", "V14", "V19") := NULL]

## rename
names(d) <- c("geonameid", "name", "asciiname",
  "lat","long", "country", "region", "population",
  "elevation", "dem", "timezone")
d[, popz := NULL]
d[, elevation := NULL]
d[, dem := NULL]
## recode
d[, dem := ifelse(dem==-9999, NA_real_, dem)]
city_data <- copy(d)
usethis::use_data(
  city_data,
  internal = TRUE
)
