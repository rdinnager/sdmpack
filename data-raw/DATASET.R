## code to prepare `DATASET` dataset goes here

library(tidyverse)

load(file = 'extdata/reef_fish_abund/01-organsiing-data24092018.RData')

RF_abund <- RLS_19

RF_sites <- read_csv("extdata/reef_fish_abund/RLS_Site_Covariates_V2_2018-09-26.csv")

RF_sites <- RF_sites |>
  select(SiteCode:pH)

#RF_species <- read_csv("extdata/reef_fish_abund/RLS_SpeciesTaxonomy.csv")

usethis::use_data(RF_abund, RF_sites, overwrite = TRUE)
