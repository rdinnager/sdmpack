library(sdmpack)
library(tidyverse)
library(rnaturalearth)
library(sf)

florida <- ne_states("united states of america", returnclass = "sf") %>%
  filter(name == "Florida") %>%
  select(geometry)

florida <- st_read("extdata/Detailed_Florida_State_Boundary") |>
  select(geometry)

usethis::use_data(florida, overwrite = TRUE)
