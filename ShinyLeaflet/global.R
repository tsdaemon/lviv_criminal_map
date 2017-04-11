Sys.setlocale("LC_CTYPE", "ukrainian")
library(leaflet)
library(geojsonio)

criminal <- read.csv("criminal.csv", encoding="UTF-8")[!is.null(criminal$Район)]

districts_geo <- geojsonio::geojson_read("district.geo.json", encoding="UTF-8", what = "sp")

districts_data <- read.csv("district.csv", encoding="UTF-8")
