ui_adaptation <- 
  list(
    layout_sidebar(
      sidebar = sidebar(
        selectInput("city_var", "City:", names_cities[10], selected = names_cities[10]),
        selectInput("season_var", "Season:", seasons[1], selected = seasons[1]),
        sliderInput("year_var", "Year:", min = 2017, max = 2022, value = 2017),
        selectInput(
          "timeday_var", "Time of day:", 
          c("Day" = "day", "Night" = "night")),
        radioButtons(
          "scenario",
          "Adaptation scenario",
          choiceNames  = list("Original", "LCZ 05", "LCZ 06", "LCZ 12"),
          selected = "orig",
          choiceValues = list("orig", "05", "06", "12")
        ),
        sliderInput(
          "transp_var", "Transparency",
          min = 0, max = 1, ticks = F,
          value = 0.8, step = 0.1
        )
      ),
      layout_columns(
        card(
          full_screen = T,
          leafletOutput("map_var"), height = "550px"),
      )
    )
  )