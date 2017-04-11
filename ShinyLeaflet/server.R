library(leaflet)
library(leaflet.extras)
library(RColorBrewer)
library(scales)
library(lattice)
library(dplyr)
library(rMaps)
library(ggplot2)

function(input, output, session) {
  
  ## Interactive Map ###########################################
  
  # Create the map
  output$map <- renderLeaflet({
    leaflet() %>% 
      addProviderTiles(providers$CartoDB.Positron) %>% 
      #addGeoJSON(districts) %>%
      
      setView(lng = 24.036021, lat = 49.8333805, zoom = 12)
  })
  
  output$bydistrictBarChart <- renderPlot({
    by_field <- selectGeoField()
    
    ggplot(districts_data, aes_string(y=by_field, x="name", fill=by_field)) + 
      geom_bar(stat="identity") +
      scale_fill_gradient(low = "#FC8D59", high = "#91CF60") + 
      labs(title = "Кількість жителів на один злочин", y="Осіб", x="Район") +
      guides(fill=guide_legend(title="Осіб")) + 
      theme(axis.text.x = element_text(angle = 90, hjust = 1))
  })
  
  
  observe({
    map <- leafletProxy("map") %>% 
      clearShapes() %>% 
      clearControls() %>% 
      clearGeoJSON() %>% 
      clearHeatmap()
    
    if(input$bydistrict) {
      
      by_field <- selectGeoField()
      pal <- colorBin("RdYlGn", districts_geo[[by_field]])
      
      persons_by_case <- round(districts_geo[[by_field]], 0)
      
      correct_spelling <- lapply(persons_by_case, function(p) {
        last_digit <- p%%10
        if(last_digit==1) "житель"
        else if(last_digit>1 && last_digit<5) "жителя"
        else "жителів"
      })
      
      labels <- sprintf(
        "<strong>%s</strong><br/>%g %s на 1 випадок",
        districts_geo$name, persons_by_case, correct_spelling
      ) %>% lapply(htmltools::HTML)
      
      map %>%
        addPolygons(data=districts_geo, 
                    fillColor = ~pal(districts_geo[[by_field]]),
                    color="Grey",
                    weight = 2,
                    opacity = 0.8,
                    fillOpacity = 0.6,
                    highlight = highlightOptions(
                      weight = 5,
                      dashArray = "",
                      fillOpacity = 0.7,
                      bringToFront = FALSE),
                    label = labels,
                    labelOptions = labelOptions(
                      style = list("font-weight" = "normal", padding = "3px 8px"),
                      textsize = "15px",
                      direction = "auto")) %>% 
        addLegend(pal = pal, 
                  values = districts_geo[[by_field]], 
                  opacity = 0.7,
                  title = "Кількість жителів на 1 злочин", 
                  position = "bottomleft")
    }
    
    if(input$dots) {
      criminalData <- filterCriminal()
      
      map %>%
        addCircles(~Longitude, ~Latitude, data=criminalData, radius=20,
                   stroke=FALSE, fillOpacity=0.4, fillColor="Red")
    }
    
    if(input$heatmap) {
      criminalData <- filterCriminal()
      
      map %>%
        addHeatmap(blur = 7, data=criminalData, radius = 4)
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
