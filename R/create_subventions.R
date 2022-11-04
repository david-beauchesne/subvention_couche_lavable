library(sf)
library(tidyverse)
munic <- sf::st_read("data/municipalites/municipalites.geojson")
subv <- utils::read.csv("data/subventions/subventions.csv")

# Add to spatial object and remove NAs 
subventions <- dplyr::left_join(munic, subv, by = c("MRC","Municipalite"))
uid <- is.na(subventions$Subvention) | 
       subventions$Subvention == "" | 
       subventions$Subvention == "NA"
subventions <- subventions[!uid, ]

sf::st_write(subventions, "data/subventions/subventions.geojson", delete_dsn = TRUE)