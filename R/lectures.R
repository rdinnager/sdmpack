#' @export
convert_learnr_to_static <- function(rmd) {

  rmd_dat <- parsermd::parse_rmd(rmd, parse_yaml = TRUE) %>%
    as_tibble()

  rmd_dat$ast[[1]]$output <- list(`prettydoc::html_pretty` = list(theme = "tactile",
                                                                  highlight = "github",
                                                                  self_contained = TRUE))
  rmd_dat$ast[[1]]$runtime <- NULL

  setup <- which(rmd_dat$label == "setup_hide")
  checks <- grep("-check", rmd_dat$label)

  rmd_dat <- rmd_dat[-c(setup, checks), ] %>%
    dplyr::mutate(ast = purrr::modify_if(ast, type == "rmd_chunk",
                                         ~ {.x$options$exercise <- NULL; .x}))

  readr::write_lines(parsermd::as_document(rmd_dat),
                     file.path("vignettes/articles", basename(rmd)))

  #new_rmd <- parsermd::render(rmd_dat, "test.html")

}
