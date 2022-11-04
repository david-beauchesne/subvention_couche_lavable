pipeline <- function() {
  # lapply(dir("R", full.names = TRUE), source)
  # Création du fichier spatial avec les MRC, municipalités et arrondissement qui offrent des 
  # subventions pour l'achat de couches lavables. 
  source("R/create_subventions.R")
  
  # Website 
  rmarkdown::render("index.Rmd")
  
}