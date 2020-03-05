#' Find geopolitical place from location string
#'
#' Converts a location string into a geopolitical place–based matches to cities
#' states, or countries
#'
#' @param x Input should be a character vector containing location strings or
#'   a data frame with a 'location' column.
#' @return Returns a data.table with the original data (character strings
#'   returned in the 'location' column) joined with geopolitical columns
#' @details This isn't exact. It's very much based on trying to make reasonable
#'   guesses.
#' @export
where <- function(x) UseMethod("where")

#' @export
where.character <- function(x) {
  x <- data.table::data.table(location = x)
  where(x)
}

#' @export
where.data.frame <- function(x) {
  x <- data.table::as.data.table(x)
  where(x)
}

#' @export
where.tbl_df <- function(x) {
  x <- data.table::as.data.table(x)
  where(x)
}

#' @import data.table
#' @export
where.data.table <- function(x) {
  stopifnot(
    "location" %in% names(x)
  )
  citydata <- data.table::as.data.table(data.table::copy(city_data))

  ##--------------------------------------------------------------------------##
  ##                                   BY CITY                                ##
  ##--------------------------------------------------------------------------##

  cities1 <- citydata[population >= 10, tolower(name)]
  cities1lab <- as.character(citydata[population >= 10, geonameid])
  cities2 <- citydata[population >= 10 & name != asciiname & asciiname != "", tolower(asciiname)]
  cities2lab <- as.character(citydata[population >= 10 & name != asciiname & asciiname != "", geonameid])
  x[, geoname_id := cities1lab[match(tfse::trim_ws(tolower(sub("\\,.*", "", location))), cities1)]]
  x[, geoname_id := ifelse(is.na(geoname_id),
    cities2lab[match(tfse::trim_ws(tolower(sub("\\,.*", "", location))), cities2)],
    geoname_id)]
  cd <- data.table::copy(citydata)
  names(cd) <- c("geoname_id", paste0("geoname_", names(cd)[-1]))
  x <- merge(x, cd[!is.na(geoname_id), ], all.x = TRUE, by = "geoname_id")

  if (!any(is.na(x[, geoname_id]))) {
    return(x)
  }
  x[, .og_order := seq_len(nrow(x))]
  xna <- data.table::copy(x[is.na(geoname_id), ])
  xna[, c("geoname_id", "geoname_name", "geoname_asciiname",
    "geoname_lat", "geoname_long", "geoname_region",
    "geoname_country", "geoname_country_name", "geoname_population",
    "geoname_timezone") := NULL]
  ##--------------------------------------------------------------------------##
  ##                                  BY STATE                                ##
  ##--------------------------------------------------------------------------##
  states <- tolower(state_data[, pat])
  stateslab <- state_data[, state_abb]

  xna[, geoname_region := stateslab[match(tfse::trim_ws(tolower(sub(".*\\, ?", "", location))), states)]]
  cd <- data.table::copy(citydata[region %in% state.abb, ])
  names(cd) <- c("geoname_id", paste0("geoname_", names(cd)[-1]))
  cd <- cd[, .(geoname_id = NA_character_,
    geoname_name = NA_character_,
    geoname_asciiname = NA_character_,
    geoname_lat = mean(geoname_lat),
    geoname_long = mean(geoname_long),
    geoname_country = geoname_country[1],
    geoname_country_name = geoname_country_name[1],
    geoname_population = sum(geoname_population),
    geoname_timezone = names(sort(table(geoname_timezone), decreasing = TRUE))[1]),
    by = geoname_region]
  xna <- merge(xna, cd, all.x = TRUE, by = "geoname_region")

  x <- rbind(x[!is.na(geoname_id), ], xna)
  x <- x[order(.og_order), ]

  if (!any(is.na(x[, geoname_region]))) {
    x[, .og_order := NULL]
    return(x)
  }
  xna <- data.table::copy(x[is.na(geoname_region), ])
  xna[, c("geoname_id", "geoname_name", "geoname_asciiname",
    "geoname_lat", "geoname_long", "geoname_region",
    "geoname_country", "geoname_country_name", "geoname_population",
    "geoname_timezone") := NULL]
  ##--------------------------------------------------------------------------##
  ##                                 BY COUNTRY                               ##
  ##--------------------------------------------------------------------------##

  countries1 <- tolower(tfse::na_omit(unique(citydata[, country])))
  countries1lab <- tfse::na_omit(unique(citydata[, country]))
  countries2 <- sub(" ?(\\,|\\().*", "",
    tolower(tfse::na_omit(unique(citydata[, country_name]))))
  countries2lab <- tfse::na_omit(unique(citydata[, country]))

  xna[, geoname_country := countries1lab[match(tfse::trim_ws(tolower(sub(".*\\, ?", "", location))), countries1)]]
  xna[, geoname_country := ifelse(
    is.na(geoname_country),
    countries2lab[match(tfse::trim_ws(tolower(sub(".*\\, ?", "", location))), countries2)],
    geoname_country)
    ]
  cd <- data.table::copy(citydata[!is.na(country), ])
  names(cd) <- c("geoname_id", paste0("geoname_", names(cd)[-1]))
  cd <- cd[, .(geoname_id = NA_character_,
    geoname_name = NA_character_,
    geoname_asciiname = NA_character_,
    geoname_lat = mean(geoname_lat),
    geoname_long = mean(geoname_long),
    geoname_region = NA_character_,
    geoname_country_name = geoname_country_name[1],
    geoname_population = sum(geoname_population),
    geoname_timezone = names(sort(table(geoname_timezone), decreasing = TRUE))[1]),
    by = geoname_country]
  xna <- merge(xna, cd, all.x = TRUE, by = "geoname_country")

  x <- rbind(x[!is.na(geoname_region), ], xna)
  x <- x[order(.og_order), ]

  x[, .og_order := NULL]
  x
}
