ui_variability <- 
  list(
    layout_sidebar(
      sidebar = sidebar(
        selectInput(
          "param", "Parameter:", 
          c("SUHI Index" = "suhi",
            "Land Surface Temp." = "lst"
          )),
        selectInput("city", "City:", names_cities, selected = names_cities[sample(1:length(names_cities), 1)]),
        selectInput("season", "Season:", seasons, selected = seasons[1]),
        sliderInput("year", "Year:", min = 2017, max = 2022, value = 2017, sep = ""),
        selectInput(
          "timeday", "Time of day:", 
          c("Day" = "day", "Night" = "night")),
        sliderInput(
          "transp", "Raster opacity",
          min = 0, max = 1, ticks = F,
          value = 0.8, step = 0.1
        )
      ),
      
      # Show results
      navset_card_tab(
        nav_panel(
          "Graphs",
          icon =  bsicons::bs_icon("file-bar-graph"),
          layout_columns(
            fill = F,
            card(
              card_header(textOutput("title_var1")),
              full_screen = T,
              leafletOutput("map"), height = "550px"),
            card(
              card_header(textOutput("title_var2")),
              full_screen = T,
              highchartOutput("chart"), height = "550px")
          )
        ),
        nav_panel(
          "Info", 
          icon =  bsicons::bs_icon("info-circle"),
          htmlOutput("var_info")
        )
      )
    )
  )