## code modifies from rundel/learnrhash (learnrhash package)
## https://github.com/rundel/learnrhash

#' @rdname learnr_elements
#' @export
decoder_logic = function() {
  p = parent.frame()

  local({
    shiny::observeEvent(
      input$decode,
      {
        output$decode_submissions = shiny::renderText(
          sdmpack:::obj_to_text(learnrhash::decode_obj(input$decode_text))
        )
      }
    )
  }, envir = p)
}

#' @rdname learnr_elements
#' @export
decoder_ui = function() {

  shiny::tags$div(
    shiny::textAreaInput("decode_text", "Hash to decode"),
    shiny::actionButton("decode", "Decode!"),
    shiny::tags$br(),
    shiny::tags$br(),
    shiny::tags$h4("Submission:"),
    learnrhash:::wrapped_verbatim_text_output("decode_submissions")
  )
}

obj_to_text = function(obj) {

  obj <- obj %>%
    dplyr::filter(type %in% c("exercise", "question"),
                  grepl("exercise_|question_", label))

  if(nrow(obj) == 0) {
    return(c("Nothing to see here! It looks like you haven't filled",
    "out and ran any code in exercises yet. Don't forget you need to",
    "click 'Test Code' or 'Run Code' before your answers will be recorded.",
    "Please try again."))
  }

  answers <- obj %>%
    dplyr::pull(answer)

  labels <- obj %>%
    dplyr::pull(label)

  text = utils::capture.output( {
    for(i in seq_along(labels)) {
      cat(labels[[i]], ": \n", sep = "")
      cat(answers[[i]], "\n\n", sep = "")
    }
  })

  paste(text, collapse="\n")
}

