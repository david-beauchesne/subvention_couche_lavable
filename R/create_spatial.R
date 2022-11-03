create_spatial <- function() {
  # https://www.donneesquebec.ca/recherche/dataset/decoupages-administratifs/resource/b368d470-71d6-40a2-8457-e4419de2f9c0
  munip <- sf::st_read("data/data-raw/municipalites/munic_s.shp")
  arron <- sf::st_read("data/data-raw/municipalites/arron_s.shp")
  shp <- dplyr::bind_rows(arron,munip)
  subv <- read.csv("data/data-raw/municipalites_subventions/municipalites.csv")
  # subv$link <- stringr::str_trim(subv$link, side = "both")

  # # Check missing
  # uid <- !subv$link %in% shp$MUS_NM_MUN & 
  #        !subv$link %in% shp$MUS_NM_MRC &
  #        !subv$link %in% shp$ARS_NM_ARR 
  shp <- dplyr::mutate(
    shp,
    Municipalite = ifelse(is.na(ARS_DE_IND), MUS_NM_MUN, ARS_NM_MUN),
    Arrondissement = ARS_NM_ARR
  ) |>
  dplyr::select(Municipalite, Arrondissement) |>
  dplyr::left_join(
    sf::st_drop_geometry(munip[,c("MUS_NM_MUN","MUS_NM_MRC")]), 
    by = c("Municipalite" = "MUS_NM_MUN")
  ) |>
  dplyr::select(MRC = MUS_NM_MRC, Municipalite, Arrondissement) |>
  dplyr::arrange(MRC, Municipalite, Arrondissement)
  
  # Ajouter liens url vers les subventions 
  shp <- dplyr::left_join( 
    shp,
    subv, 
    by = c("MRC", "Municipalite", "Arrondissement")
  ) |>
  dplyr::filter(!is.na(url)) |>
  unique()
  
  # Export
  sf::st_write(shp, "./data/data-raw/subventions/subventions.geojson", delete_dsn = TRUE)
}