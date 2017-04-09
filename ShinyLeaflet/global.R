Sys.setlocale("LC_CTYPE", "ukrainian")
library(jsonlite)
library(leaflet)

criminal <- read.csv("../criminal.csv", encoding="UTF-8")
districts <- readLines("../polygons/district.geo.json", warn=FALSE) %>% 
              paste(collapse = "\n") %>%
              fromJSON(simplifyVector = FALSE)

districts$style = list(
  weight = 1,
  color = "#f03b20",
  fillColor = "#f03b20",
  opacity = 1,
  fillOpacity = 0.3
)