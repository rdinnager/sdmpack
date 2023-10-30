library(sdmpack)
library(tidyverse)
library(stars)

data("florida")

bioclim_files <- list.files("extdata/bioclim", full.names = TRUE)

bioclim <- read_stars(bioclim_files)

bioclim_fl <- bioclim %>%
  st_crop(florida |> st_bbox())

#write_stars(bioclim_fl, "extdata/bioclim_fl.tif", progress = TRUE)

bioclim_files_fl <- gsub("bioclim", "bioclim_fl", bioclim_files)

for(i in seq_along(bioclim_files)) {
  if(!file.exists(bioclim_files_fl[i])) {
    write_stars(bioclim_fl[i], bioclim_files_fl[i])
  }
  print(i)
}


bioclim_fl <- read_stars(list.files("extdata/bioclim_fl", full.names = TRUE),
                         along = "band")

bioclim_vars <- tribble(~short_name, ~description,
                        "BIO1", "Annual Mean Temperature",
                        "BIO2", "Mean Diurnal Range (Mean of monthly (max temp - min temp))",
                        "BIO3", "Isothermality (BIO2/BIO7) (×100)",
                        "BIO4", "Temperature Seasonality (standard deviation ×100)",
                        "BIO5", "Max Temperature of Warmest Month",
                        "BIO6", "Min Temperature of Coldest Month",
                        "BIO7", "Temperature Annual Range (BIO5-BIO6)",
                        "BIO8", "Mean Temperature of Wettest Quarter",
                        "BIO9", "Mean Temperature of Driest Quarter",
                        "BIO10", "Mean Temperature of Warmest Quarter",
                        "BIO11", "Mean Temperature of Coldest Quarter",
                        "BIO12", "Annual Precipitation",
                        "BIO13", "Precipitation of Wettest Month",
                        "BIO14", "Precipitation of Driest Month",
                        "BIO15", "Precipitation Seasonality (Coefficient of Variation)",
                        "BIO16", "Precipitation of Wettest Quarter",
                        "BIO17", "Precipitation of Driest Quarter",
                        "BIO18", "Precipitation of Warmest Quarter",
                        "BIO19", "Precipitation of Coldest Quarter")

bioclim_fl <- st_set_dimensions(bioclim_fl,
                                "band",
                                bioclim_vars$short_name)

usethis::use_data(bioclim_fl, overwrite = TRUE)
usethis::use_data(bioclim_vars, overwrite = TRUE)

