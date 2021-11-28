#' Compare means/proportions across a group
#'
#' Compares the means/proportions across grouping by `group`. Produces a p- value for each comparsion.
#'
#' @param df a dataframe
#' @param group the grouping variable; must be a `logical` vector
#' @param ... columns to compare means/proportions
#'
#' @details This function produces either a `t.test` or a `chisq.test` on each of the columns in `...`. If the variable `is.numeric`, conducts `t.test`. If the variable `is.logical` or `is.factor`, conducts `chisq.test`. Note that if you are piping into this function with a variable created by `dplyr::group_by()` as as your grouping function, you must first `dplyr::ungroup()` prior to piping into `compare()` (see example).
#'
#' @return a data frame
#'
#' @importFrom stats chisq.test t.test
#' @importFrom rlang :=
#'
#' @export
#'
#' @examples mtcars %>% dplyr::group_by(hp > 150) %>% dplyr::ungroup() %>% comparison(`hp > 150`, hp, am)
#'
comparison <- function(df, group, ...) {
  vars <- rlang::ensyms(...)
  group <- rlang::ensym(group)

  stopifnot("group should be a logical vector" = is.logical(df %>% dplyr::pull(!!group)))

  group_name_false <- paste(rlang::as_name(group), "false", sep="_")
  group_name_true <- paste(rlang::as_name(group), "true", sep="_")

  df %>%
    dplyr::select(c(!!!vars)) %>%
    purrr::imap_dfr(function(.x, .y) {
      x <- rlang::eval_tidy(rlang::quo(choose_test(df, !!group, !!.y)))
      broom::tidy(x) %>%
      dplyr::mutate(rowname = .y, (!!group_name_false) := x$false, (!!group_name_true) := x$true) %>%
      dplyr::select(rowname, (!!group_name_false), (!!group_name_true), p.value, method)
    })
}

#' Choose the correct statistical test
#'
#' Selects the correct statistical test for a provided dataframe column.
#'
#' @param df a data frame
#' @param group a grouping variable to split the records in `col` and test by.
#' @param col a column to be tested
#'
#' @return a list of class `htest` representing the results of either `chisq.test` or `t.test`
#'
#' @details currently does not work with factors, only logicals and numerics.
#'
#' @export
#'
#' @examples mtcars %>% dplyr::group_by(hp > 150) %>% choose_test(`hp > 150`, mpg)
#'
choose_test <- function(df, group, col) {
  col <- rlang::as_name(rlang::ensym(col))
  group <- rlang::as_name(rlang::ensym(group))

  stopifnot("group should be a logical vector" = is.logical(df[[group]]))

  if(is.logical(df[[col]])) {
    x <- chisq.test(table(df[[col]], df[[group]]))
    x$false <- x$observed["TRUE","FALSE"]/sum(x$observed[,"FALSE"])*100
    x$true <- x$observed["TRUE","TRUE"]/sum(x$observed[,"TRUE"])*100
    return(x)
  } else if(is.numeric(df[[col]])) {
    x <- rlang::eval_tidy(rlang::quo(t.test(make_formula(!!col, !!group), data = df)))
    x$false <- x$estimate[1]
    x$true <- x$estimate[2]
    return(x)
  } else {
    stop("Can not apply either chi-square or t.test to column ", col)
  }
}


