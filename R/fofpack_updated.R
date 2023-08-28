#' Check if fofpack is up to date.
#'
#' Always make sure fofpack is up to date before starting any assignment!
#'
#' @return Invisibly returns `TRUE` if fofpack is up to date, `FALSE` otherwise
#' @export
#'
#' @examples
#' fofpack_up_to_date()
fofpack_up_to_date <- function() {
  fofpack_updated <- rvcheck::check_github("rdinnager/fofpack")
  learnr_updated <- rvcheck::check_github("rstudio/learnr")

  if(!fofpack_updated$up_to_date || !learnr_updated$up_to_date) {
    message('fofpack or a required package is not up-to-date.
            Please reinstall fofpack and check if it worked with the following commands:
            devtools::install_github("rdinnager/fofpack", dependencies = TRUE, upgrade = TRUE, force = TRUE)
            library(fofpack)
            fofpack_up_to_date()
            The above commands have been copied to the clipboard for you.
            Pay attention while the package is reinstalling, the console may ask
            you a question. If it does you must type an answer for the reinstallation
            to complete. ')
    clipr::write_clip('devtools::install_github("rdinnager/fofpack", dependencies = TRUE, upgrade = TRUE, force = TRUE)
                      library(fofpack)
                      fofpack_up_to_date()')

    return(invisible(FALSE))
  } else {
    message("Everything looks up to date for fofpack!")
    return(invisible(TRUE))
  }

}
