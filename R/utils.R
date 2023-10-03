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

## function borrowed from package {TeachingDemos} function char2seed(): https://cran.r-project.org/web/packages/TeachingDemos/index.html

#' @export
set.seed.by.name <- function(x, set = TRUE, ...){

	tmp <- c(0:9,0:25,0:25)
	names(tmp) <- c(0:9,letters,LETTERS)

	x <- gsub("[^0-9a-zA-Z]","",as.character(x))

	xsplit <- tmp[ strsplit(x,'')[[1]] ]

	seed <- sum(rev( 7^(seq(along=xsplit)-1) ) * xsplit)
        seed <- as.integer( seed %% (2^31-1) )

	if(set){
		set.seed(seed,...)
		return(invisible(seed))
	} else {
		return(seed)
	}
}

