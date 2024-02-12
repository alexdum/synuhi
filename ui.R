

ui <- 
  page_fillable(
    layout_sidebar(
      sidebar = sidebar(
        selectInput("city", "City:", names_cities, selected = names_cities[sample(1:length(names_cities), 1)]),
        selectInput("season", "Season:", seasons, selected = seasons[1]),
        sliderInput("year", "Year:", min = 2017, max = 2022, value = 2017),
        selectInput(
          "timeday", "Time of day:", 
          c("Day" = "day", "Night" = "night"))
      ),
      
      # Show results
      navset_card_tab(
        full_screen = T,
        title = "TBA",
        nav_panel(title = "Map",  leafletOutput("map"))
        
      )
    )
  )

