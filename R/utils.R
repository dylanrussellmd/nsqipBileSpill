#' Calculate percentage
#'
#' Returns a percentage TRUE given a logical vector.
#'
#' @param vec a logical vector
#'
#' @return a numeric vector
#'
#' @export
#'
#' @examples get_percent(mtcars$hp > 150)
#'
get_percent <- function(vec) {
  stopifnot("vec should be a logical vector" = is.logical(vec))
  avg(vec)*100
}

#' Calculate an average
#'
#' Returns an average from a numeric vector, automatically removes all NA values.
#'
#' @param vec a numeric vector
#'
#' @return a numeric vector
#'
#' @export
#'
#' @examples avg(c(10, 10, 10, NA))
#'
avg <- function(vec) {
  mean(vec, na.rm = TRUE)
}

#' Calculate BMI
#'
#' @param height a numeric vector
#' @param weight a numeric vector
#'
#' @return a numeric vector
#'
#' @export
#'
#' @examples bmi(72, 180)
#'
bmi <- function(height, weight) {
  703 * weight/(height^2)
}

#' Calculate an odds ratio
#'
#' Given a data frame, a risk factor column, and an outcome column, calculate odds ratio via \code{epitools::\link[epitools:oddsratio]{oddsratio()}}. Allows non-standard evaluation for use in `dplyr` pipes.
#'
#' @param df a data frame
#' @param exposure a logical vector representing a risk factor or exposure
#' @param outcome a logical vector representing an outcome
#'
#' @return a list object produced by \code{epitools::\link[epitools:oddsratio]{oddsratio()}}
#'
#' @examples
#' df <- data.frame(poison = c(TRUE, TRUE, FALSE, FALSE), death = c(TRUE, FALSE, TRUE, FALSE))
#' df %>% odds_ratio(poison, death)
#'
#' @export
#'
odds_ratio <- function(df, exposure, outcome) {
  cols <- rlang::ensyms(exposure, outcome)
  rf <- rlang::ensym(exposure)
  oc <- rlang::ensym(outcome)

  stopifnot("exposure should be a logical vector" = is.logical(df %>% dplyr::pull(!!rf)))
  stopifnot("outcome should be a logical vector" = is.logical(df %>% dplyr::pull(!!oc)))

  df %>%
    dplyr::select(!!!cols) %>%
    table() %>%
    {suppressWarnings(epitools::oddsratio(.))}
}
