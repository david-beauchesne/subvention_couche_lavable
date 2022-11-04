library(sf)
library(tidyverse)
munic <- sf::st_read("data/data-raw/subventions/municipalites.geojson")
subv <- utils::read.csv("data/data-raw/subventions/municipalites_link.csv")

# Add to spatial object and remove NAs 
subventions <- dplyr::left_join(munic, subv, by = c("MRC","Municipalite"))
uid <- is.na(subventions$Subvention) | 
       subventions$Subvention == "" | 
       subventions$Subvention == "NA"
subventions <- subventions[!uid, ]

sf::st_write(subventions, "data/data-raw/subventions/subventions.geojson", delete_dsn = TRUE)