#' Not in operator
#'
#' Negates the `%in%` operator. See \code{base::\link[base:match]{match}} for details.
#'
#' @param lhs a vector containing values to be matched
#' @param rhs a vector to compare `lhs` to
#'
#' @name %nin%
#' @rdname nin
#' @export
#' @examples
#' "dog" %nin% c("cat","giraffe","elephant")
#' "dog" %nin% c("dog","giraffe","elephant")
#'
'%nin%' <- function(lhs, rhs) {
  match(lhs, rhs, nomatch = 0) == 0
}
