library(shiny)
library(leaflet)
library(terra)
library(bslib)
library(sf)
library(dplyr)
library(seas)
library(highcharter)

source("utils/leaflet_fun.R", local = T)


cities <- st_read("www/data/shp/cities_merged.geojson", quiet = T) |> arrange(name) |> filter(name != "Constanta")

names_cities <- setNames(cities$cod, cities$name)


day <- rast("www/data/ncs/SENTINEL3B_SLSTR_L3C_0.01_SUHI_intensity_day.nc")
time(day[[3]]) <- as.Date("2017-01-15") # ajustare timp pentru vizualizare
night <- rast("www/data/ncs/SENTINEL3B_SLSTR_L3C_0.01_SUHI_intensity_night.nc")

seasons <-  mkseas(time(day), "DJF") |> unique() |> as.character()

seasons <- setNames(seasons, seasons)
domain_suhi <- c(-10, 10)
pal_rev_suhi <- colorNumeric("RdYlBu", domain = domain_suhi, reverse = F, na.color = "transparent")
pal_suhi <- colorNumeric("RdYlBu", domain = domain_suhi, reverse = T, na.color = "transparent")
