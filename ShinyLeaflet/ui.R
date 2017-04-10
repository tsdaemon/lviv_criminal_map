library(leaflet)
library(leaflet.extras)

presentation_vals <- c("Точки" = "dots", 
               "Heat map" = "heatmap", 
               "По районах" = "bydistrict")

type_vals <- c("Усі" = "all", 
               "Крадіжки" = "theft", 
               "Пограбування" = "robbery",
               "Шахрайства" = "fraud")

# Choices for drop-downs
navbarPage("Кримінальні випадки Львова", id="nav",
           
    tabPanel("Карта",
      div(class="outer",
          
        tags$head(
          # Include our custom CSS
          includeCSS("styles.css"),
          includeScript("gomap.js")
        ),
        
        leafletOutput("map", width="100%", height="100%"),
        
        # Shiny versions prior to 0.11 should use class="modal" instead.
        absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
            draggable = TRUE, top = 60, left = "auto", right = 20, bottom = "auto",
            width = 330, height = "auto",
            
            h2("Налаштування"),
            
            
            selectInput("type", "Тип запису", type_vals, selected = "all"),
            
            selectInput("presentation", "Представлення", presentation_vals, selected = "bydistrict")
        ),
        
        tags$div(id="cite",
           'Підготоване з використанням ', tags$a(href='http://opendata.city-adm.lviv.ua/', "Портала відкритих даних Львова"), ' Анатолієм Стегнієм (2017).'
         )
      )
   )
)

