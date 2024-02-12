#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)

# Define server logic required to draw a histogram
function(input, output, session) {
    
    data_sel <- reactive({
        
        city_sub <- cities |> filter(cod %in% input$city)
        list(city_sub = city_sub)
    })
    
    # functie leaflet de start
    output$map <- renderLeaflet({
        leaflet_fun()
    })
    
    observe({
        
        data <- data_sel()$city_sub
        print(head(data))

        # pentru zoom retea observatii vizualizata
        bbox <- st_bbox(data) |> as.vector()
        
        leafletProxy("map") |>
            addPolygons(
                data = cities,
                stroke = TRUE,color = "yellow",opacity = 1,
                fillColor =  "#444444", weight = 1, smoothFactor = 0.5,
                options = pathOptions(pane = "cities"),
                group = "Cities") |>
            fitBounds(bbox[1], bbox[2], bbox[3], bbox[4])
    })
    
}
