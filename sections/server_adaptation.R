data_selvar <- reactive({
  
  # subseteaza limita city
  city_sub <- cities |> filter(cod %in% input$city_var)
  city_sub_buf <- cities_buf |> filter(cod %in% input$city_var)
  
  # citeste fisier raster
  if (input$scenario %in% "orig") {
    r <- rast(paste0("www/data/ncs/SENTINEL3B_SLSTR_L3C_0.01_SUHI_",input$timeday_var,".nc"))
    time(r[[3]]) <- as.Date("2017-01-15") # ajustare timp pentru vizualizare
    
  } else {
    r <- rast(paste0("www/data/ncs/SENTINEL3B_SLSTR_L3C_0.01_SUHI_",input$timeday_var,"_", input$scenario,".nc"))
    time(r[[3]]) <- as.Date("2017-01-15") # ajustare timp pentru vizualizare
    
  }
  
  
  
  # subsetare raster pentru harta
  ri <- r[[which(paste(format(time(r), "%Y"), mkseas(time(r), "DJF")) %in% paste(input$year_var, input$season_var))]]
  
  
  domain_r <- c(-10, 10)
  pal_rev <- colorNumeric("RdYlBu", domain = domain_r, reverse = F, na.color = "transparent")
  pal <- colorNumeric("RdYlBu", domain = domain_r, reverse = T, na.color = "transparent")
  
  
  # ajustare conform domeniului pentru vizualizare
  ri[ri >  domain_r[2]] <-  domain_r[2]
  ri[ri <  domain_r[1]] <-  domain_r[1]
  
  
  
  list(city_sub = city_sub, city_sub_buf = city_sub_buf, ri = ri,  domain_r =  domain_r, pal = pal, pal_rev = pal_rev)
})


# functie leaflet de start
output$map_var <- renderLeaflet({
  
  leaflet_fun()
})

observe({
  
  rr <- data_selvar()$ri
  data <- data_selvar()$city_sub_buf
  pal <- data_selvar()$pal
  pal_rev <- data_selvar()$pal_rev
  domain_r <- data_selvar()$domain_r
  # pentru zoom retea observatii vizualizata
  bbox <- st_bbox(data) |> as.vector()
  
  
  leafletProxy("map_var") |>
    addPolygons(
      data =  cities,
      color = "#252525", weight = 2, smoothFactor = 0.5,
      opacity = 0.7, fillOpacity = 0.0,
      options = pathOptions(pane = "cities"),
      group = "Cities") |>
    addPolygons(
      data = cities_buf,
      color = "#252525", weight = 2, smoothFactor = 0.5,
      opacity = 0.7, fillOpacity = 0.0,
      options = pathOptions(pane = "cities_buf"),
      group = "Cities buffer") |>
    clearImages() |>
    addRasterImage(
      rr, colors = pal, opacity = input$transp_var,
      group = "SUHI") |> 
    clearControls() |>
    addLegend(
      title =  "SUHI [°C]",
      position = "bottomright",
      pal = pal_rev, values = domain_r,
      opacity = input$transp_var,
      labFormat = labelFormat(transform = function(x) sort(x, decreasing = TRUE))) |>
    fitBounds(bbox[1], bbox[2], bbox[3], bbox[4])
  
  print(bbox)
  
})

# variabile grafic
chart_vars2 <- reactiveValues(df = NULL, coordinates = NULL)

# pentru actualizare grafice cu schimbare oras
observeEvent(input$city_var,{ 
  city_sub_buf <- data_selvar()$city_sub_buf
  cent <- st_centroid(city_sub_buf) |> st_coordinates()
  co <- data.frame(lng = cent[1,1], lat = cent[1,2])
  chart_vars2$coordinates <- co
  print( chart_vars2$coordinates)
})
