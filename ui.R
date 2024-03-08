ui <- 
  page_fillable(
    layout_sidebar(
      sidebar = sidebar(
        selectInput("city", "City:", names_cities, selected = names_cities[sample(1:length(names_cities), 1)]),
        selectInput("season", "Season:", seasons, selected = seasons[1]),
        sliderInput("year", "Year:", min = 2017, max = 2022, value = 2017),
        selectInput(
          "timeday", "Time of day:", 
          c("Day" = "day", "Night" = "night")),
        sliderInput(
          "transp", "Transparency",
          min = 0, max = 1, ticks = F,
          value = 0.8, step = 0.1
        )
      ),
      
      # Show results
      card_header(
        textOutput("title_map")
      ),
      layout_columns(
        fill = F,
        card(
          full_screen = T,
          leafletOutput("map", height = "450px")
        ),
        card(
          full_screen = T,
          highchartOutput("chart", height = "450px")# %>% withSpinner(size = 0.5)
        )
      )
      
      # navset_card_tab(
      #   full_screen = T,
      #   title = "TBA",
      #   nav_panel(title = "Map",  leafletOutput("map")),
      #   nav_panel(title = "Graph",  highchartOutput("chart"))
      #   
      # )
    )
  )

