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
    
    ri <- r[[which(paste(format(time(r), "%Y"), mkseas(time(r), "DJF")) %in% paste(input$year, input$season))]]
    
    # pentru extragere date sezone
    rs <- r[[which(mkseas(time(r), "DJF") %in% input$season)]]
    
    
    ri[ri > 10] <- 10
    ri[ri < -10] <- -10
    
    list(city_sub = city_sub, ri = ri, rs = rs)
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
        color = "#252525", weight = 1, smoothFactor = 0.5,
        opacity = 0.7, fillOpacity = 0.0,
        options = pathOptions(pane = "cities"),
        group = "Cities") |>
      addRasterImage(
        ri, colors = pal_suhi, opacity = .8,
        group = "SUHI") |> 
      fitBounds(bbox[1], bbox[2], bbox[3], bbox[4]) |>
      clearControls() %>%
      addLegend(
        title =  "SUHI [°C]",
        position = "bottomright",
        pal = pal_rev_suhi, values = domain_suhi,
        opacity = 1,
        labFormat = labelFormat(transform = function(x) sort(x, decreasing = TRUE))
      ) 
  })
  
  
  # variabile grafic
  chart_vars <- reactiveValues(df = NULL, coordinates = NULL)
  
  # pentru actualizare grafice cu schimbare oras
  observeEvent(input$city,{ 
    city_sub <- data_sel()$city_sub 
    cent <- st_centroid(city_sub) |> st_coordinates()
    co <- data.frame(lng = cent[1,1], lat = cent[1,2])
    chart_vars$coordinates <- co
    print( chart_vars$coordinates)
  })
  
  # pentru actualizare grafice cu click
  observeEvent(input$map_click, { 
    ids <- input$map_click
    co <- data.frame(lng = ids$lng, lat = ids$lat)
    chart_vars$coordinates <- co
    print( chart_vars$coordinates)
  })
  
  output$chart <- renderHighchart({
    
    rs <- data_sel()$rs
    rs_ex <- terra::extract(rs, cbind(chart_vars$coordinates$lng, chart_vars$coordinates$lat))
    df <- data.frame(ani = as.numeric(format(time(rs), "%Y")), val = unlist(rs_ex[1,]))
    
    hchart(object = df, type = "column", hcaes(x = ani, y = val), color = 'red')  |>
      hc_title(text = toString(chart_vars$coordinates))
    
  })
  
}
