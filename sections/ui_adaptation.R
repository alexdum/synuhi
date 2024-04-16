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
              bsicons::bs_icon("info-circle"),
              "SUHI adaptation scenario based on modified Local Climate Zones classes (LCZ). See Info subsection.",
              placement = "right"
            )
          ),
          choiceNames  = list("Unmodified LCZ", "LCZ 02 to LCZ 05", "LCZ 02 to LCZ 06", "LCZ 02 to LCZ 12"),
          selected = "orig",
          choiceValues = list("orig", "05", "06", "12")
        ),
        sliderInput(
          "transp_adapt", "Raster opacity",
          min = 0, max = 1, ticks = F,
          value = 1, step = 0.1
        )
      ),
      navset_card_tab(
        nav_panel(
          "Graphs",
          icon =  bsicons::bs_icon("file-bar-graph"),
          layout_columns(
            fill = F,
            card(
              card_header(textOutput("title_adapt1")),
              full_screen = T,
              highchartOutput("chart_adapt"), height = "550px"),
            card(
              card_header(textOutput("title_adapt2")),
              full_screen = T,
              leafletOutput("map_adapt"), height = "550px")
          ),
          accordion(
            open = F,
            accordion_panel(
              "Data", icon = bsicons::bs_icon("table",  class = "d-flex justify-content-between align-items-center"),
              DT::dataTableOutput('table_adapt')
            )
          )
        ),
        nav_panel(
          "Info", 
          icon =  bsicons::bs_icon("info-circle"),
          includeMarkdown("sections/adaptation_info.qmd")
        )
      )
      
    )
  )