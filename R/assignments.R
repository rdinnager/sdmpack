#' Write your submitted answers from the assignment to a text file
#'
#' `r lifecycle::badge('deprecated')`
#' This function is no longer required because of the new submission system
#' incorporated directly into assignments.
#'
#' Get a text file of your answers to the assignment that you can upload to
#' Canvas.
#'
#' @param week What week's assignment do you want your answers for? This should
#' be numeric.
#' @param where Where do you want it? That is, in which directory on your computer
#' do you want to write the text file. Defaults to your working directory.
#'
#' @return The path to a text file with answers
#' @export
#'
#' @examples
#' write_answers(3)
write_answers <- function(week, where = getwd()) {
  answer_file <- file.path(system.file(package = "fofpack"), "answers",
                      paste0("week_", week, "_answers.txt"))
  if(!file.exists(answer_file)) {
    stop("Sorry, answers for week ", week, " cannot be found.")
  }
  file.copy(file.path(system.file(package = "fofpack"), "answers",
                      paste0("week_", week, "_answers.txt")),
            where,
            overwrite = TRUE)
}
