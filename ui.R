

ui <- 
  page_fillable(
    layout_sidebar(
      sidebar = sidebar(
        selectInput("city", "City:", names_cities, selected = names_cities[sample(1:length(names_cities), 1)]),
      ),
      
      # Show results
      navset_card_tab(
        full_screen = T,
        title = "TBA",
        nav_panel(title = "Map",  leafletOutput("map"))
        
      )
    )
  )

