# Define server logic required to draw a histogram
function(input, output, session) {
  
  data_sel <- reactive({
    
    city_sub <- cities |> filter(cod %in% input$city)
    
    # subsetare raster
    if (input$timeday %in% "day" ) {
      r <- day
    } else {
      r <- night
    }
    
    ri <- r[[which(paste(format(time(r), "%Y"), mkseas(time(r), "DJF")) %in% input$season)]]
    
    ri[ri > 5] <- 5
    ri[ri < -5] <- -5
    
    list(city_sub = city_sub, ri = ri)
  })
  
  # functie leaflet de start
  output$map <- renderLeaflet({
    leaflet_fun()
  })
  
  observe({
    data <- data_sel()$city_sub
    ri <- data_sel()$ri
    # pentru zoom retea observatii vizualizata
    bbox <- st_bbox(data) |> as.vector()
    
    leafletProxy("map") |>
      addPolygons(
        data = cities,
        color = "yellow", weight = 1, smoothFactor = 0.5,
        opacity = 0.7, fillOpacity = 0.0,
        options = pathOptions(pane = "cities"),
        group = "Cities") |>
      addRasterImage(ri, colors = pal_suhi, opacity = .8) |> 
      fitBounds(bbox[1], bbox[2], bbox[3], bbox[4])
  })
  
}
