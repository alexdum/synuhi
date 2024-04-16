

output$guide <- renderUI({
  tags$iframe(src = "html/guide.html", height = "100%", width = "100%")
})