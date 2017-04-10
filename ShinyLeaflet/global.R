Sys.setlocale("LC_CTYPE", "ukrainian")
library(leaflet)
library(geojsonio)

criminal <- read.csv("../criminal.csv", encoding="UTF-8")
# districts_geo <- readLines("../district.geo.json", warn=FALSE, encoding="UTF-8") %>% 
#               paste(collapse = "\n") %>%
#               fromJSON(simplifyVector = FALSE)

districts_geo <- geojson_read("../district.geo.json", encoding="UTF-8")

districts_data <- read.csv("../district.csv", encoding="UTF-8")
