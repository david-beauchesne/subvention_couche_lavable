# Adjust dataset manually with shapefiles of municipalities
# https://www.donneesquebec.ca/recherche/dataset/decoupages-administratifs/resource/b368d470-71d6-40a2-8457-e4419de2f9c0
# https://www.donneesquebec.ca/recherche/dataset/decoupages-administratifs/resource/a30825b5-82d2-491d-9783-c513fe36f231
munip <- sf::st_read("data/municipalites-1-100000/munic_s.shp")
# arron <- sf::st_read("data/municipalites/arron_s.shp")

# Conserver uniquement les colonnes d'intérêt
munip <- dplyr::select(
  munip,
  MRC = MUS_NM_MRC,
  Municipalite = MUS_NM_MUN
) |>
dplyr::arrange(MRC, Municipalite) |>
dplyr::group_by(MRC, Municipalite) |>
dplyr::summarise(geometry = sf::st_union(geometry)) |>
dplyr::ungroup()

# arron <- dplyr::select(
#   arron, 
#   Municipalite = ARS_NM_MUN,
#   Arrondissement = ARS_NM_ARR
# )

# Ajouter MRC aux arrondissements 
# arron <- dplyr::left_join(arron, sf::st_drop_geometry(munip), by = "Municipalite")

# Retrait  des municipalites qui ont des arrondissements 
# munip <- munip[!munip$Municipalite %in% unique(arron$Municipalite), ]

# Combinaison des jeux de données
# shp <- dplyr::bind_rows(munip,arron) |>
# dplyr::arrange(MRC, Municipalite, Arrondissement) |>
# dplyr::group_by(MRC, Municipalite, Arrondissement) |>
# dplyr::summarise(geometry = sf::st_union(geometry)) |>
# dplyr::ungroup()

# Retrait des TNO aquatiques et terrestres
uid <- stringr::str_detect(munip$Municipalite, "TNO aquatique") |
       stringr::str_detect(munip$Municipalite, "TNO terrestre")
munip <- munip[!uid,]

# data.frame only 
dat <- sf::st_drop_geometry(munip)
write.csv(dat, file = "data/municipalites/municipalites_all.csv", row.names = FALSE)

# export spatial 
sf::st_write(munip, "data/municipalites/municipalites.geojson")

# # Initiating list from the one available on Éco bébé, keeping it, but I made my own dataset from that and this code should not be used again
# library(tidyverse)
# library(rvest)
# url <-  "https://couchesecobebe.com/pages/liste-des-villes-municipalites-et-arrondissements-offrant-une-subvention-pour-lachat-de-couches-lavables"
# 
# scraplinks <- function(url){
#     # Create an html document from the url
#     webpage <- xml2::read_html(url)
#     # Extract the URLs
#     url_ <- webpage %>%
#         rvest::html_nodes("a") %>%
#         rvest::html_attr("href")
#     # Extract the link text
#     link_ <- webpage %>%
#         rvest::html_nodes("a") %>%
#         rvest::html_text()
#     return(tibble(link = link_, url = url_))
# }
# 
# links <- scraplinks(url)
# links <- links[29:284, ] |>
#          filter(link != "")
# 
# write.csv(links, file = "data/subventions/subvention_list.csv", row.names = FALSE)

