# Define server logic required to draw a histogram
function(input, output, session) {
  
  data_sel <- reactive({
    
    # subseteaza limita city
    city_sub <- cities |> filter(cod %in% input$city)
    
    # citeste fisier raster
    r <- rast(paste0("www/data/ncs/SENTINEL3B_SLSTR_L3C_0.01_",toupper(input$param),"_",input$timeday,".nc"))
    time(r[[3]]) <- as.Date("2017-01-15") # ajustare timp pentru vizualizare
    
    # subsetare raster pentru harta
    ri <- r[[which(paste(format(time(r), "%Y"), mkseas(time(r), "DJF")) %in% paste(input$year, input$season))]]
    
    if (input$param %in% "suhi") {
      domain_r <- c(-10, 10)
      pal_rev <- colorNumeric("RdYlBu", domain = domain_r, reverse = F, na.color = "transparent")
      pal <- colorNumeric("RdYlBu", domain = domain_r, reverse = T, na.color = "transparent")
    } else {
      
      ri_crop <- crop(ri, ext(city_sub))
      
      domain_r <-minmax(ri_crop)
     pals <-  map_cols_fun(indic = "lst", domain_r )
      pal_rev <- pals$pal_rev
      pal <-  pals$pal
    }
    
    # ajustare conform domeniului pentru vizualizare
    ri[ri >  domain_r[2]] <-  domain_r[2]
    ri[ri <  domain_r[1]] <-  domain_r[1]
    
   
    
    list(city_sub = city_sub, ri = ri,  domain_r =  domain_r, pal = pal, pal_rev = pal_rev)
  })
  
  # functie leaflet de start
  output$map <- renderLeaflet({
    leaflet_fun()
  })
  
  observe({
    data <- data_sel()$city_sub
    ri <- data_sel()$ri
    pal <- data_sel()$pal
    pal_rev <- data_sel()$pal_rev
    domain_r <- data_sel()$domain_r
    # pentru zoom retea observatii vizualizata
    bbox <- st_bbox(data) |> as.vector()
    
    
    leafletProxy("map") |>
      addPolygons(
        data = cities,
        color = "#252525", weight = 1, smoothFactor = 0.5,
        opacity = 0.7, fillOpacity = 0.0,
        options = pathOptions(pane = "cities"),
        group = "Cities") |>
      clearImages() |>
      addRasterImage(
        ri, colors = pal, opacity = input$transp,
        group = toupper(input$param)) |> 
      clearControls() |>
      addLegend(
        title =  paste(toupper(input$param), "[°C]"),
        position = "bottomright",
        pal = pal_rev, values = domain_r,
        opacity = input$transp,
        labFormat = labelFormat(transform = function(x) sort(x, decreasing = TRUE))) |>
      fitBounds(bbox[1], bbox[2], bbox[3], bbox[4])
  })
  
  
  # variabile grafic
  chart_vars <- reactiveValues(df = NULL, coordinates = NULL)
  
  # pentru actualizare grafice cu schimbare oras
  observeEvent(input$city,{ 
    city_sub <- data_sel()$city_sub 
    cent <- st_centroid(city_sub) |> st_coordinates()
    co <- data.frame(lng = cent[1,1], lat = cent[1,2])
    chart_vars$coordinates <- co
  })
  
  # pentru actualizare grafice cu click
  observeEvent(input$map_click, { 
    ids <- input$map_click
    co <- data.frame(lng = ids$lng, lat = ids$lat)
    chart_vars$coordinates <- co
  })
  
  output$chart <- renderHighchart({
    
    # pentru limite grafic
    domain_r <- data_sel()$domain_r
    
    # citeste fisier raster pentru grafic
    r <- rast(paste0("www/data/ncs/SENTINEL3B_SLSTR_L3C_0.01_",toupper(input$param),"_",input$timeday,".nc"))
    time(r[[3]]) <- as.Date("2017-01-15") # ajustare timp pentru vizualizare
    
    
    # pentru extragere date sezone
    rs <- r[[which(mkseas(time(r), "DJF") %in% input$season)]]
    
    rs_ex <- terra::extract(rs, cbind(chart_vars$coordinates$lng, chart_vars$coordinates$lat))
    
    # ploteazaca cand ai valoare cand nu afiseaza mesaj
    if (!all(is.na(rs_ex))) {
      
      df <- data.frame(ani = as.numeric(format(time(rs), "%Y")), val = unlist(rs_ex[1,]) |> round(1))
      df$color <- ifelse(df$val > 0, "#ca0020", "#0571b0")
      
      highchart() |>
        hc_add_series(data = df, "column",
                      hcaes(x = ani, y = val, color = color),
                      showInLegend = F) |> 
        hc_title(
          text = paste(toupper(input$param),"values extracted at lon: ",chart_vars$coordinates$lng, "lat: ", chart_vars$coordinates$lat),
          style = list(fontSize = "14px", color = "grey")) |>
        hc_yAxis(
          max = domain_r[2], min = domain_r[1],
          title = list(text = paste(toupper(input$param), "[°C]"))
        ) |>
        hc_xAxis(
          title = list(text = "")
        )
    } else {
      highchart() |> 
        hc_title(
          text = "Click on the area with available pixel values",
          style = list(fontSize = "14px", color = "grey"))
    }
    
  })
  
  output$title_map <- renderText({
    paste(toupper(input$param), toupper(input$timeday), input$season, input$year, names(names_cities[names_cities == input$city]))
  })
  
}
