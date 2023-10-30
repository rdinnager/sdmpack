library(fofpack)
library(sf)
library(dplyr)

data(florida)

ecoregions <- read_sf("extdata/ecoregions")

ecoregions <- st_make_valid(ecoregions)

ecoregions_fl <- st_intersection(ecoregions, florida)

plot(ecoregions_fl %>%
       select(ECO_NAME), key.pos = 1)

ecoregions_fl <- ecoregions_fl %>%
  select(ECO_NAME)

usethis::use_data(ecoregions_fl, overwrite = TRUE)
