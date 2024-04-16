# Define server logic required to draw a histogram
function(input, output, session) {
  
  source("sections/server_variability.R", local = T)
  source("sections/server_adaptation.R", local = T)
  source("sections/server_guide.R", local = T)
  
  # pentru incarcare si map_adpat nac_se`
  outputOptions(output, "map_adapt", suspendWhenHidden = FALSE)
}
