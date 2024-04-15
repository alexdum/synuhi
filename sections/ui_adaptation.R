ui_adaptation <- 
  list(
    layout_sidebar(
      sidebar = sidebar(
        selectInput("city_adapt", "City:", names_cities[10], selected = names_cities[10]),
        selectInput("season_adapt", "Season:", seasons[1], selected = seasons[1]),
        sliderInput("year_adapt", "Year:", min = 2017, max = 2022, value = 2017),
        selectInput(
          "timeday_adapt", "Time of day:", 
          c("Day" = "day", "Night" = "night")),
        radioButtons(
          "scenario",
          span(
            "Adaptation scenario",
            tooltip(
              bsicons::bs_icon("question-circle"),
              "SUHI adaptation scenario based on modified Local Climate Zones classes (LCZ)",
              placement = "right"
            )
          ),
          choiceNames  = list("Original", "LCZ 05", "LCZ 06", "LCZ 12"),
          selected = "orig",
          choiceValues = list("orig", "05", "06", "12")
        ),
        sliderInput(
          "transp_adapt", "Transparency",
          min = 0, max = 1, ticks = F,
          value = 1, step = 0.1
        )
      ),
      layout_columns(
        fill = F,
        card(
          full_screen = T,
          highchartOutput("chart_adapt"), height = "550px"),
        card(
          full_screen = T,
          leafletOutput("map_adapt"), height = "550px")
        
      )
    )
  )