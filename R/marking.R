#' Convert a submitted hash code to a learnr document
#' for marking
#'
#' @param hash_code Character. hash code to convert
#' @param assignment_path Path to assignment .Rmd
#'
#' @return
#' @export
#'
#' @examples
convert_hash_code <- function(hash_code, assignment_path,
                              rmd_path = tempfile(fileext = ".Rmd"),
                              student = "Test student",
                              run = TRUE) {

  rmd_dat <- parsermd::parse_rmd(assignment_path, parse_yaml = TRUE) %>%
    as_tibble()

  ast_classes <- lapply(rmd_dat$ast, class)

  hash_dat <- learnrhash::decode_obj(hash_code)
  rmd_dat <- rmd_dat %>%
    left_join(hash_dat %>%
                select(label, type2 = type, answer)) %>%
    mutate(type2 = replace_na(type2, "")) %>%
    mutate(new_ast = map_if(transpose(list(ast, answer)),
                            type2 == "exercise",
                            ~ assign_in(.x[[1]], "code", .x[[2]]),
                            .else = ~ .x[[1]])) %>%
    mutate(ast = new_ast) %>%
    select(-type2:-new_ast)

  class(rmd_dat$ast) <- c("rmd_ast", "list")

  rmd_dat$ast[[1]]$title <- paste(rmd_dat$ast[[1]]$title,
                                  "->", student)

  write_lines(parsermd::as_document(rmd_dat),
             rmd_path)

  if(run) {
    learnr::run_tutorial(rmd_path)
  }

  list(file = rmd_path, answers = hash_dat %>%
         left_join(learnr::get_tutorial_info(assignment_path)$items %>%
                     select(label, order)) %>%
         arrange(order))

}

generate_assignments <- function(path,
                                 assignment_path,
                                 output_path = path) {
  ext <- tools::file_ext(path)
  if(ext == "zip") {
    dir <- tempdir()
    unzip(path, exdir = dir)
    path <- dir
  }
  files <- list.files(path, full.names = TRUE,
                      pattern = ".html")

  htmls <- map(files,
               rvest::read_html)

  students <- map_chr(htmls,
                      possibly(
                        ~ rvest::html_element(.x, "head > title") %>%
                          rvest::html_text(),
                        otherwise = "Unknown"
                      ))

  hashes <- map(htmls,
                possibly(~ rvest::html_elements(.x, xpath = "/html/body/div/pre/text()") %>%
                           rvest::html_text(),
                         otherwise = "",
                         quiet = TRUE))

  failed <- map_lgl(hashes, ~ length(.x) == 0 || .x == "")

  hashes2 <- map_if(htmls,
                   failed,
                   possibly(~ rvest::html_elements(.x, xpath = "/html/body/div/p/text()") %>%
                              rvest::html_text(),
                            otherwise = ""))

  hashes[failed] <- hashes2[failed]

  failed <- map_lgl(hashes, ~ length(.x) == 0 || .x == "")

  hashes3 <- map_if(htmls,
                   failed,
                   possibly(~ rvest::html_elements(.x, xpath = "/html/body/div/article/div/div/div/pre/text()") %>%
                              rvest::html_text(),
                            otherwise = ""))

  hashes[failed] <- hashes3[failed]

  hashes[map_int(hashes, length) > 1] <- ""

  failed <- map_lgl(hashes, ~ length(.x) == 0)

  hashes[failed] <- rep("Something went wrong. You probably will have to generate this assignment manually.",
                        sum(failed))

  hashes <- flatten_chr(hashes)

  rmds <- file.path(output_path,
                    gsub(".html", ".Rmd", basename(files)))

  res <- pmap(list(hashes, rmds, students),
             possibly(~ convert_hash_code(..1,
                                 assignment_path,
                                 ..2,
                                 student = ..3,
                                 run = FALSE),
                      otherwise = list()))

  res

}
