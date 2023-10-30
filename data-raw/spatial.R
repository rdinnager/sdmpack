
library(gdalUtilities)
library(sf)
library(sdmpack)
library(tidyverse)
library(terra)

data(IRC)

parks <- st_read("extdata/parks_shape")


IRC_sf <- IRC %>%
  group_by(area_name) %>%
  summarise(long = long[1], lat = lat[1]) %>%
  filter(!is.na(long), !is.na(lat)) %>%
  st_as_sf(coords = c("long", "lat"),
           crs = 4326,
           remove = FALSE) %>%
  st_transform(st_crs(parks))

irc_spat <- IRC_sf %>%
  st_join(parks,
          join = st_nearest_feature) %>%
  filter(!is.na(MANAME)) %>%
  as_tibble() %>%
  select(-geometry) %>%
  left_join(parks %>%
              select(MANAME)) %>%
  st_as_sf()

# write_rds(irc_spat, "data/irc_spat.rds")
# rm(irc_spat)
# rm(parks)
# rm(IRC_sf)
# rm(IRC)

######### land cover ##############

#CLC <- rast("data/CLC_raster/CLC_v3_5_Raster.gdb")
CLC <- st_read("C:/Projects/fofpack/extdata/CLC_v3_5.gdb")

ensure_multipolygons <- function(X) {
    tmp1 <- tempfile(fileext = ".gpkg")
    tmp2 <- tempfile(fileext = ".gpkg")
    st_write(X, tmp1)
    ogr2ogr(tmp1, tmp2, f = "GPKG", nlt = "MULTIPOLYGON")
    Y <- st_read(tmp2)
    st_sf(st_drop_geometry(X), geom = st_geometry(Y))
}

CLC <- CLC %>%
  ensure_multipolygons()
write_sf(CLC, "extdata/CLC.geojson")


irc_lc <- irc_spat %>%
  st_transform(st_crs(CLC)) %>%
  st_join(CLC %>%
            select(NAME_STATE) %>%
            mutate(id = 1:n()))

CLC_overlapped <- CLC %>%
  slice(unique(irc_lc$id)) %>%
  select(NAME_STATE)

irc_lc_CLC <- st_intersection(irc_spat, CLC_overlapped)

write_rds(irc_lc_CLC, "data/intermed_result.rds")

irc_lc_CLC <- irc_lc_CLC %>%
  mutate(area = st_area(geometry))

irc_final <- irc_lc_CLC %>%
  as_tibble() %>%
  select(-geometry) %>%
  group_by(area_name, NAME_STATE) %>%
  summarise(area = sum(as.numeric(area))) %>%
  group_by(area_name) %>%
  mutate(prop = area / sum(area))

parks_LC <- irc_final

usethis::use_data(parks_LC, overwrite = TRUE)
