run_exam_1 <- function() {
  download_file <- "https://raw.githubusercontent.com/rdinnager/fofpack/main/inst/tutorials/exam_1/exam_1.Rmd"
  local_file <- file.path(system.file("tutorials", package = "fofpack"), "exam_1", "exam_1.Rmd")
  good <- download.file(download_file, local_file)
  if(good == 0) { message("Exam download successful!") } else {
    local_file <- file.path(getwd(), "exam_1.Rmd")
    good <- download.file(download_file, local_file)
    if(good == 0) { message("Exam download successful!") } else { warning("Exam download failed") }
  }
  learnr::run_tutorial(local_file)
}

