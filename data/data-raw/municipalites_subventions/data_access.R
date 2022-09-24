# Initiating list from the one available on Éco bébé
library(tidyverse)
library(rvest)
url <-  "https://couchesecobebe.com/pages/liste-des-villes-municipalites-et-arrondissements-offrant-une-subvention-pour-lachat-de-couches-lavables"

df <- url |>
  read_html() |>
  html_nodes("p") |>
  html_text()
  html_table(fill = T) 
  
  df <- url |>
    read_html() |>
    html_nodes("div") |>
        html_text()
        

scraplinks <- function(url){
    # Create an html document from the url
    webpage <- xml2::read_html(url)
    # Extract the URLs
    url_ <- webpage %>%
        rvest::html_nodes("a") %>%
        rvest::html_attr("href")
    # Extract the link text
    link_ <- webpage %>%
        rvest::html_nodes("a") %>%
        rvest::html_text()
    return(tibble(link = link_, url = url_))
}

links <- scraplinks(url)
links <- links[29:284, ] |>
         filter(link != "")

write.csv(links, file = "data/data-raw/municipalites_subventions/municipalites.csv", row.names = FALSE)