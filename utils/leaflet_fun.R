leaflet_fun <- function() {
  
  map <- leaflet(
    #data = data,
    options = leafletOptions(
      minZoom = 7, maxZoom = 12
    ) 
  ) %>%
    leaflet.extras::addBootstrapDependency() %>%
    setView(25, 46, zoom = 4) %>%
    setMaxBounds(20, 43.5, 31, 48.2) |>
    #addMapPane(name = "SUHI", zIndex = 420) %>%
    #addMapPane(name = "judete", zIndex = 430) %>%
    addMapPane(name = "cities", zIndex = 440) %>%
    addMapPane(name = "maplabels", zIndex = 450) %>%
    addProviderTiles( "CartoDB.Positron", group = "CartoDB")  %>% 
    addProviderTiles( "Esri.WorldGrayCanvas", group = "EsriWorldGray") |> 
    addProviderTiles( "Esri.WorldImagery", group = "EsriWorldImagery") |> 
    addEasyButton(
      easyButton(
        icon    = "glyphicon glyphicon-home", title = "Reset zoom",
        onClick = JS("function(btn, map){ map.setView([46, 25], 6); }")
      )
    ) |>
    # addPolylines(
    #     data =  jud,
    #     color = "#444444", weight = 1, smoothFactor = 0.5,
    #     options = pathOptions(pane = "judete"),
    #     group = "Județe") |>
    # addPolygons(
    #   data = cities,
    #   stroke = TRUE,color = "yellow",opacity = 1,
    #   fillColor =  "#444444", weight = 1, smoothFactor = 0.5,
    #   options = pathOptions(pane = "cities"),
    #   group = "Cities") |>
    addLayersControl(
      baseGroups = c("EsriWorldImagery","CartoDB","EsriWorldGray"),
      overlayGroups = c("Labels","Cities")) |> 
     #hideGroup("SUHI") |>
    # pentru poztionare raster mereu in top
    htmlwidgets::onRender(" 
    function(el, x) {
      this.on('baselayerchange', function(e) {
        e.layer.bringToBack();
      })
    }
  ") |>
 
    addProviderTiles(
      "CartoDB.PositronOnlyLabels",
      options = pathOptions(pane = "maplabels"),
      group = "Labels"
    ) %>%
    addScaleBar(
      position = c("bottomleft"),
      options = scaleBarOptions(metric = TRUE)) 
  
  
  return(map)
}