library(fofpack)
library(tidyverse)

data("parks_LC")
data(IRC)

parks_LC <- parks_LC %>%
  left_join(IRC %>%
              group_by(area_name) %>%
              summarise(long = long[1],
                        lat = lat[1]))

usethis::use_data(parks_LC, overwrite = TRUE)
