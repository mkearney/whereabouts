## code to prepare `state_data` dataset goes here


state_names <- c("Alabama",
  "Alaska",
  "Arizona",
  "Arkansas",
  "(California|Cali)",
  "Colorado",
  "(Connecticut|Conn)",
  "Delaware",
  "(Florida|Flo)",
  "Georgia",
  "Hawaii",
  "Idaho",
  "Illinois",
  "Indiana",
  "Iowa",
  "Kansas",
  "Kentucky",
  "Louisiana",
  "Maine",
  "Maryland",
  "(Massachusetts|Mass)",
  "(Michigan|Mich)",
  "(Minnesota|Minn)",
  "Mississippi",
  "Missouri",
  "Montana",
  "Nebraska",
  "Nevada",
  "N(ew)?.{0,3}Hampshire",
  "N(ew)?.{0,3}Jersey",
  "N(ew)?.{0,3}Mexico",
  "N(ew)?.{0,3}York",
  "N(orth)?.{0,3}Carolina",
  "N(orth)?.{0,3}Dakota",
  "Ohio",
  "Oklahoma",
  "Oregon",
  "(Pennsylvania|Penn)",
  "R(hode)?.{0,3}Island",
  "S(outh)?.{0,3}Carolina",
  "S(outh)?.{0,3}Dakota",
  "(Tennessee|Tenn)",
  "(Texas|Tex)",
  "Utah",
  "Vermont",
  "Virginia",
  "Washington",
  "W(est)?.{0,3}Virginia",
  "Wisconsin",
  "Wyoming"
)

sn <- data.table::data.table(
  state_abb = state.abb,
  state_abb_dot = ifelse(grepl(" ", state.name), gsub("(?<=\\w)", ".", state.abb, perl = TRUE), NA_character_),
  state_name = state.name,
  state_name_dot = ifelse(grepl(" ", state.name), sub("(?<=^[A-Z])\\w+(?= )", ".", state.name, perl = TRUE), NA_character_),
  state_name_nosp = ifelse(grepl(" ", state.name), sub(" ", "", state.name), NA_character_),
  state_other = NA_character_
)
sn$state_other[c(3, 4, 5, 7, 8, 9, 13, 14, 21, 22, 23, 27, 28, 29, 30, 32, 37, 38, 42, 43, 49, 50)] <- c(
  "Ariz", "Ark", "Cali", "Conn", "Dware", "Flo", "Ill", "Indi", "Mass", "Mich", "Minn",
  "Neb", "Nev", "Hampshire", "Jersey", "NYNY", "Oreg", "Penn", "Tenn", "Tex", "Wisc", "Wyom")
sn <- do.call("rbind", lapply(sn, function(.x)
  data.table::data.table(state_abb = sn[, state_abb], state_full = sn[, state_name], pat = .x)))
sn <- sn[!is.na(pat), ]
state_data <- copy(sn)
usethis::use_data(
  city_data,
  state_data,
  internal = TRUE,
  overwrite = TRUE
)
