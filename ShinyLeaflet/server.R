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
  
  
  observe({
    map <- leafletProxy("map") %>% 
      clearShapes() %>% 
      clearControls() %>% 
      clearGeoJSON() %>% 
      clearHeatmap()
    
    if(input$presentation == "dots") {
      criminalData <- filterCriminal()
      
      map %>%
        addCircles(~Longitude, ~Latitude, data=criminalData, radius=40,
                   stroke=FALSE, fillOpacity=0.4, fillColor="Red")
    }
    
    if(input$presentation == "bydistrict") {
      by_field <- selectGeoField()
      
      var <- sapply(districts_geo$features, function(feat) {
        as.double(feat$properties[[by_field]])
      })
      
      pal <- colorBin("YlOrRd", var)
      
      districts_geo$features <- lapply(districts_geo$features, function(feat) {
        label <- htmltools::HTML(sprintf(
          "<strong>%s</strong><br/>%g осіб на 1 випадок",
          feat$properties$name, round(1/feat$properties[[by_field]], digits = 0)
        ))
        
        feat$properties$style <- list(
          color="Orange",
          fillColor = pal(feat$properties[[by_field]]),
          weight = 2,
          opacity = 0.8,
          highlight = highlightOptions(
            weight = 5,
            color = "#666",
            dashArray = "",
            fillOpacity = 0.9,
            bringToFront = TRUE),
          label <- label,
          labelOptions = labelOptions(
            style = list("font-weight" = "normal", padding = "3px 8px"),
            textsize = "15px",
            direction = "auto")
        )
        feat
      })
      
      map %>%
        addGeoJSON(districts_geo) %>% 
        addLegend(pal = pal, values = vars, opacity = 0.7, title = "Кількість випадків на 1 особу", position = "bottomleft")
    }
    
    if(input$presentation == "heatmap") {
      criminalData <- filterCriminal()
      
      map %>%
        addHeatmap(blur = 8, data=criminalData, radius = 4, gradient="plasma")
    }
    
    map
  })
  
  selectGeoField <- function() {
    if(input$type == "theft") {
      "theft_by_population"
    } else if(input$type == "robbery") {
      "robbery_by_population"
    } else if(input$type == "fraud") {
      "fraud_by_population"
    } else {
      "total_by_population"
    }
  }
  
  filterCriminal <- function() {
    if(input$type == "theft") {
      criminal[criminal$Тип == "Крадіжка",]
    } else if(input$type == "robbery") {
      criminal[criminal$Тип == "Пограбування",]
    } else if(input$type == "fraud") {
      criminal[criminal$Тип == "Шахрайство",]
    } else {
      criminal
    }
  }
}
