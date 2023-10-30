library(fofpack)

data("IRC")

ecmwfr::wf_set_key(user = "156994",
                   key = "6f20b9e0-1d0c-4488-95db-daf9cffef7f7",
                   service = "cds")

bbox_irc <- IRC %>%
  summarise(min_x = min(long, na.rm = TRUE) - 0.1,
            min_y = min(lat, na.rm = TRUE) - 0.1,
            max_x = max(long, na.rm = TRUE) + 0.1,
            max_y = max(lat[lat < 1000], na.rm = TRUE) + 0.1) %>%
  unlist()

xmn <- bbox_irc[1]
xmx <- bbox_irc[3]
ymn <- bbox_irc[2]
ymx <- bbox_irc[4]

st_time <- lubridate::ymd("2010:01:03")
en_time <- lubridate::ymd("2010:12:25")


file_prefix <- "era5-south_florida-2012"

file_path <- file.path("extdata/era5", file_prefix)


req <- mcera5::build_era5_request(xmin = xmn, xmax = xmx,
                                  ymin = ymn, ymax = ymx,
                                  start_time = st_time,
                                  end_time = en_time,
                                  outfile_name = file_path)

mcera5::request_era5(request = req, uid = "156994", out_path = file_path,
                     overwrite = TRUE)


usethis::use_data(PR_parks, overwrite = TRUE)

