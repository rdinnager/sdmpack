#' Send an environment to RStudio Session
#'
#' @param env_from The environment to send
#'
#' @return Nothing
#' @export
send_env_to_RStudio <- function(env_from, remove = "dput_to_string") {
  fn <- suppressWarnings(normalizePath(tempfile(), winslash = "/"))
  obs <- setdiff(c(rlang::env_names(env_from),
                   rlang::env_names(rlang::global_env())),
                 remove)
  save(list = obs,
       file = fn, envir = env_from)
  rstudioapi::sendToConsole(paste0("load('", fn, "')"),
                            echo = FALSE,
                            focus = FALSE)
}

#' Synchronise an environment with another
#'
#' This function takes everything in an environment and puts it
#' in another, replacing any existing object with the same names.
#'
#' @param env_from The environment to synchronise with
#' @param env_to The environment to synchronise
#'
#' @return Nothing
#' @export
set_env <- function(env_from, env_to = rlang::global_env()) {
  rlang::env_unbind(env_to, rlang::env_names(env_from))
  rlang::env_coalesce(env_to, env_from)
}
