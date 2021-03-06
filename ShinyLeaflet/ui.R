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
navbarPage("Кримінальна карта Львова", id="nav",
           
    tabPanel("",
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
            
            checkboxInput("dots", "Точки"),
            
            checkboxInput("heatmap", "Heatmap"),
            
            checkboxInput("bydistrict", "Райони", value = TRUE),
            
            plotOutput("bydistrictBarChart", height = 400)
        ),
        
        tags$div(id="cite",
           'Підготовано з використанням ', tags$a(href='http://opendata.city-adm.lviv.ua/', "Портала відкритих даних Львова"), ' Анатолієм Стегнієм (2017).'
         )
      )
   )
)

