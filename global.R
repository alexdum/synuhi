library(shiny)
library(leaflet)
library(terra)
library(bslib)
library(sf)
library(dplyr)

source("utils/leaflet_fun.R", local = T)


cities <- st_read("www/data/shp/cities_merged.geojson", quiet = T) |> arrange(name)

names_cities <- setNames(cities$cod, cities$name)
