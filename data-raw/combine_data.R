library(sdmpack)

data("IRC")
data("parks_LC")

PR_parks <- parks_LC %>%
  filter(NAME_STATE == "Pine Rockland",
         prop > 0.05)

PR_parks <- parks_LC %>%
  select(area_name) %>%
  distinct() %>%
  left_join(PR_parks %>%
              mutate(Pine_Rockland = "Present") %>%
              select(area_name, Pine_Rockland)) %>%
  mutate(Pine_Rockland = ifelse(is.na(Pine_Rockland), "Absent", Pine_Rockland) %>%
           as.factor())

spec_preds <- IRC %>%
  mutate(Occurrence = ifelse(Occurrence == "Present", 1, 0)) %>%
  select(area_name, ScientificName, Occurrence) %>%
  distinct(area_name, ScientificName, .keep_all = TRUE) %>%
  pivot_wider(names_from = ScientificName,
              values_from = Occurrence)

PR_parks <- PR_parks %>%
  left_join(spec_preds)

parks_LC_wide <- parks_LC %>%
  select(area_name, NAME_STATE, prop) %>%
  mutate(NAME_STATE = paste("LC:", NAME_STATE)) %>%
  pivot_wider(names_from = NAME_STATE, values_from = prop,
              values_fill = 0) %>%
  drop_na()

usethis::use_data(PR_parks, overwrite = TRUE)
usethis::use_data(parks_LC_wide, overwrite = TRUE)

