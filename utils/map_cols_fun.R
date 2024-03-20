cols_tas <- c("#F7FCFD","#EBF4F8","#E0ECF4","#CFDFED","#BFD3E6","#AEC7E0","#9EBCDA","#95A9D0","#8C96C6","#8C80BB", "#8C6BB1", "#8A56A7","#88419D","#0000ff","#0049ff","#0072ff","#00a3ff","#00ccff","#00e5ff","#00ffff","#007700","#009900","#00bb00","#00dd00","#00ff00","#7fff00","#cfff00","#ffff00","#ffe500","#ffcc00","#ffad00","#ff9900","#ff7f00","#FF4E00","#F23A00","#E42700","#D81300","#CB0000","#A62137","#9D3673","#813986","#532B6E", "#532B6E")
colint_pr <- colorRampPalette(brewer.pal(9,"BuPu"),interpolate = "linear") 
colintYlOrRd <- colorRampPalette( brewer.pal(9,"YlOrRd"),interpolate = "linear")
colintRdYlBu <- colorRampPalette(brewer.pal(10,"RdYlBu"),interpolate = "linear")
colintBlues <- colorRampPalette(brewer.pal(9,"Blues"), interpolate = "linear")
colintReds <- colorRampPalette(brewer.pal(9,"Reds"), interpolate = "linear")
colintBrBG <- colorRampPalette(brewer.pal(11,"BrBG"),interpolate = "linear")

map_cols_fun <- function(indic = NA,  domain = NA) {
  
  if (indic %in% c("lst")) { # pentru toate temperaturile
    
      df.col <- data.frame(
        cols = cols_tas, 
        vals = c(-40,-38,-36,-34,-32,-30,-28,-26,-24,-22,-20,-18,-16,-14,-12,-10,-8,-6,-4,-2,0,2,4,6,8,10,12,14,16,18,20,22,24,26,28,30,32,34,36,38,40,42,44)							
      ) 
      leaflet_titleg <- paste0("<html>", gsub(",","",toString(rep("&nbsp;", 5))), "°C","</html>")
  }
  
  # print(head(df.col))
  # print(domain)
  ints <- findInterval(domain, df.col$vals, rightmost.closed = T, left.open = F)
  
  bins <-  df.col$vals[ints[1]:(ints[2] + 1)]
  cols <- df.col$cols[ints[1]:(ints[2])]
  
  # print(bins)
  # print(cols)
  # 
  pal <- colorBin(cols, domain = domain, bins = bins, na.color = "transparent")
  pal2 <- colorBin(cols, domain = domain, bins = bins, reverse = T, na.color = "transparent")
  
  return(list(pal = pal, pal_rev = pal2, tit_leg = leaflet_titleg))
  
}