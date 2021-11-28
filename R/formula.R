#' Create a formula
#'
#' Creates a new formula object to be used anywhere formulas are used (i.e, `glm`).
#'
#' @param ... any number of arguments to compose the formula
#' @param lhs a boolean indicating if the formula has a left hand side of the argument
#' @param op the operand acting upon the arguments of the right side of the formula.
#' @param group an argument to use as a grouping variable to facet by
#'
#' @return a formula
#'
#' @details If `lhs` is `TRUE`, the first argument provided is used as the left hand side of the formula.
#' The `group` paramenter will add `| group` to the end of the formula. This is useful for packages that support faceting by grouping variables for the purposes of tables or graphs.
#'
#' @export
#'
#' @examples
#' make_formula(var1, var2, var3)
#' make_formula(var1, var2, var3, lhs = FALSE)
#' make_formula(var1, var2, var3, lhs = FALSE, group = var4)
#'
make_formula <- function(..., lhs = TRUE, op = "+", group = NULL) {
  args <- rlang::ensyms(...)
  n <- length(args)
  group <- rlang::enexpr(group)

  if(lhs) {
    left <- args[[1]]
    if (n == 1) {
      right <- 1
    } else if (n == 2) {
      right <- args[[2]]
    } else {
      right <- purrr::reduce(args[-1], function(out, new) call(op, out, new))
    }
  } else {
    left <- NULL
    if (n == 1) {
      right <- args[[1]]
    } else {
      right <- purrr::reduce(args, function(out, new) call(op, out, new))
    }
  }

  if(!is.null(group)) {
    group <- rlang::ensym(group)
    right <- purrr::reduce(c(right, group), function(out, new) call("|", out, new))
  }

  rlang::new_formula(left, right, env = rlang::caller_env()) # Forward to the caller environment
}
