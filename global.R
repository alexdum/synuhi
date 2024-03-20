library(shiny)
library(leaflet)
library(terra)
library(bslib)
library(sf)
library(dplyr)
library(seas)
library(highcharter)
library(RColorBrewer)

source("utils/leaflet_fun.R", local = T)
source("utils/map_cols_fun.R", local = T)


cities <- st_read("www/data/shp/cities_merged.geojson", quiet = T) |> arrange(name) |> filter(name != "Constanta")
names_cities <- setNames(cities$cod, cities$name)


seasons <-  mkseas(time(day), "DJF") |> unique() |> as.character()
seasons <- setNames(seasons, seasons)

