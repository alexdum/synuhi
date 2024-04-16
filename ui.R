source("sections/ui_variability.R", local = T)
source("sections/ui_adaptation.R", local = T)

ui <- 
  page_navbar(
    theme = bs_theme(
      preset = "shiny"
    ),
    lang = "en",
    fillable_mobile = T,
    position = "static-top",
    
    nav_panel("Variability", ui_variability),
      
      # navset_card_tab(
      #   full_screen = T,
      #   title = "TBA",
      #   nav_panel(title = "Map",  leafletOutput("map")),
      #   nav_panel(title = "Graph",  highchartOutput("chart"))
      #   
      # )
    
    nav_panel("Adaptation", ui_adaptation),
    nav_panel(
      class = "bslib-page-dashboard",
      "Guide",
      htmlOutput("guide")
    )
  )

