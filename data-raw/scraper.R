library(rvest)
library(stringr)
library(tidyverse)

url <- "https://regionalconservation.org/ircs/database/site/ConservationAreas.asp"

html <- read_html(url)

areas <- html_elements(html, "#habitatsTable td:nth-child(1)") %>%
  .[-1] %>%
  html_elements('a') %>%
  html_attr('href')

get_data_for_area <- function(area, wait = 1) {

  Sys.sleep(wait)

  area_url <- gsub("..", "https://regionalconservation.org/ircs/database",
                   area, fixed = TRUE)

  area_url <- gsub(" ", "%20", area_url)

  area_html <- read_html(area_url)

  area_name <- html_element(area_html, "font b") %>% html_text()

  area_dat <- html_table(area_html)

  if(length(area_dat) != 6) {
    return(NULL)
  }

  lat_long <- area_dat[[2]][[1, 1]]
  csize <- str_match(lat_long, "Size:(.*?)Latitude")[1, 2] %>%
    str_trim()
  lat <- str_match(lat_long, "Latitude:(.*?)º")[1, 2] %>%
    str_trim() %>%
    as.numeric()
  long <- str_match(lat_long, "Longitude:(.*?)º")[1, 2] %>%
    str_trim() %>%
    as.numeric()

  spec_dat <- area_dat[[4]]

  spec_dat$`Scientific Name:` <- str_match(spec_dat$`Scientific Name:`,
                                           "Scientific Name:(.*?)Occurrence")[ , 2] %>%
    str_trim()

  spec_dat <- spec_dat %>%
    mutate(size = csize,
           long = long,
           lat = lat,
           area_name = area_name,
           error = NULL)

  print(area_name)

  spec_dat

}

# test_areas <- sample(areas, 10)
#
# test <- test_areas %>%
#   map(get_data_for_area)

## Test works, run on all areas

all_dat <- map(areas,
               safely(~ get_data_for_area(.x)))

all_df <- transpose(all_dat)

all_df <- bind_rows(all_df$result)

readr::write_csv(all_df, "data/IRC.csv")
