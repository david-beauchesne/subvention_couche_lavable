library(sf)
library(tidyverse)
munic <- sf::st_read("data/data-raw/subventions/municipalites.geojson")
subv <- utils::read.csv("data/data-raw/subventions/municipalites_link.csv")

# Sélectionner uniquement les endroits avec des subventions 
uid <- subv$Subvention != ""
subv <- subv[uid, ]

# Add to spatial object and remove NAs 
subventions <- dplyr::left_join(munic, subv, by = c("MRC","Municipalite","Arrondissement"))
uid <- subventions$Subvention != ""
subventions <- subventions[uid, ]

