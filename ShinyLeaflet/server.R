library(leaflet)
library(leaflet.extras)
library(RColorBrewer)
library(scales)
library(lattice)
library(dplyr)
library(rMaps)

function(input, output, session) {
  
  ## Interactive Map ###########################################
  
  # Create the map
  output$map <- renderLeaflet({
    leaflet() %>% 
      addProviderTiles(providers$CartoDB.Positron) %>% 
      #addGeoJSON(districts) %>%
      
      setView(lng = 24.036021, lat = 49.8333805, zoom = 12)
  })
  
  # A reactive expression that returns the set of zips that are
  # in bounds right now
  criminalInBounds <- reactive({
    if (is.null(input$map_bounds))
      return(criminal[FALSE,])
    bounds <- input$map_bounds
    latRng <- range(bounds$north, bounds$south)
    lngRng <- range(bounds$east, bounds$west)
    
    subset(criminal,
           Latitude >= latRng[1] & Latitude <= latRng[2] &
             Longitude >= lngRng[1] & Longitude <= lngRng[2])
  })
  
  
  observe({
    colorData <- criminal$Тип
    pal <- colorFactor(c("#1b9e77", "#d95f02", "#7570b3"), colorData)
    
    
    leafletProxy("map", data=criminalInBounds) %>%
      clearShapes() %>%
      addCircles(~Longitude, ~Latitude, radius=30,
                stroke=FALSE, fillOpacity=0.4, fillColor=pal(colorData)) %>%
      addLegend("bottomleft", pal=pal, values=colorData, title="Тип",
                layerId="colorLegend")
      #addPolygons(stroke = FALSE, smoothFactor = 0.3, fillOpacity = 1)
      #addGeoJSON(districts)
  })
}
