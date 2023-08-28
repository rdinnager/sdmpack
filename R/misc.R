#' @export
make_data <- function(IRC, parks_LC, species) {
  IRC %>%
    filter(ScientificName == species) %>%
    left_join(parks_LC) %>%
    drop_na() %>%
    mutate(size = parse_number(size))
}
