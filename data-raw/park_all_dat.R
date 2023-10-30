library(sdmpack)
library(tidyverse)
library(terra)

data("IRC")
data("parks_LC")
data("parks_LC_wide")
data("bioclim_vars")

bc <- rast(list.files("extdata/bioclim", full.names = TRUE))

coords <- parks_LC %>%
  ungroup() %>%
  select(area_name, long, lat) %>%
  distinct(long, lat, .keep_all = TRUE)

bc_dat <- extract(bc, coords %>% select(long, lat))

bc_dat <- as.data.frame(bc_dat) %>%
  select(temp_mean_bio01 = wc2.1_30s_bio_1,
         temp_variation_bio04 = wc2.1_30s_bio_4,
         rainfall_mean_bio12 = wc2.1_30s_bio_12,
         rainfall_variation_bio15 = wc2.1_30s_bio_15)

parks_dat <- coords %>%
  bind_cols(bc_dat) %>%
  left_join(parks_LC_wide)

miami_parks <- IRC %>%
  left_join(parks_dat %>%
              select(-long, -lat))

usethis::use_data(miami_parks, overwrite = TRUE)
