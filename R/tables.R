#' Make a Table 1
#'
#' This function provides a wrapper around \code{table1::\link[table1:table1]{table1}} that allows it to
#' create a column for P-values and perform the appropriate statistical tests. It also adds functionality
#' for captions and table numbering.
#'
#' @param df a dataframe
#' @param group a group to split the columns by. Must be a logical or a factor with two levels.
#' @param ... a list of columns to be included in the table
#' @param negative_label a word to prepend to the label of the negative `group` (see example)
#' @param caption an optional caption
#' @param table_num an optional table number
#'
#' @return an HTML table
#'
#' @details Currently only works if you intend to split by the variable `group`, which must be a logical or a factor with two levels.
#'
#' @importFrom stats chisq.test t.test
#'
#' @export
#'
#' @examples
#' diamonds <- ggplot2::diamonds
#' diamonds$expensive <- diamonds$price > 500
#' Hmisc::label(diamonds$depth) <- "Depth"
#' Hmisc::label(diamonds$table) <- "Table"
#' Hmisc::label(diamonds$price) <- "Price"
#' Hmisc::label(diamonds$clarity) <- "Clarity"
#' Hmisc::label(diamonds$cut) <- "Cut"
#' Hmisc::label(diamonds$expensive) <- "Expensive"
#' diamonds %>% make_table1(group = expensive, depth, clarity, cut, negative_label = "Not")
#'
make_table1 <- function(df, group, ..., negative_label = "No", caption, table_num) {
  group <- rlang::ensym(group)

  # Converts a logical column into a factor column for use in grouping data.
  # Also adds a dummy "P-value" level in order to hack in the P-value into the table.
  make_factor <- function(df, group, negative_label) {
    if(!is.factor(df[[group]])) {
      label <- rlang::as_name(group)
      true_label <- stringr::str_to_sentence(label)
      false_label <- paste(negative_label, label, sep = " ")
      factor(df[[group]], levels = c(TRUE, FALSE, "p"), labels = c(true_label, false_label, "P-value"))
    }
    else df[[group]]
  }
  # A function factory that creates a `render` function to be used with the table1::table1 function.
  # Also chooses the appropriate statistical test (t.test for numeric, chisq.test for logical/factor)
  render_fac <- function(df, group) {
    function(x, name, ...) {
      if (length(x) == 0) {
        y <- df[[name]]
        s <- rep("", length(table1::render.default(x=y, name=name, ...)))
        if (is.numeric(y)) {
          p <- t.test(y ~ df[[group]])$p.value
        } else {
          p <- chisq.test(table(y, droplevels(df[[group]])))$p.value # Should I use simulate.p.value?
        }
        s[2] <- sub("<", "&lt;", format.pval(p, digits=2, eps=0.01))
        s
      } else {
        table1::render.default(x=x, name=name, ...)
      }
    }
  }
  # Creates the stratification label render function.
  render_strat <- function(label, n, ...) {
    ifelse(n==0, label, table1::render.strat.default(label, n, ...))
  }

  render <- render_fac(df, group)
  formula <- make_formula(..., lhs = FALSE, group = !!group)
  df[[group]] <- make_factor(df, group, negative_label)

  if(!rlang::is_missing(caption) && !rlang::is_missing(table_num)) {
    cap <- paste("<p id='tab:table",table_num,"'> Table ",table_num,": ",caption,"</p>", sep = "")
    table1::table1(formula, data = df, droplevels = FALSE, overall=FALSE, render = render, render.strat = render_strat, caption = cap)
  } else if(rlang::is_missing(caption) && !rlang::is_missing(table_num)) {
    cap <- paste("<p id='tab:table",table_num,"'> Table ",table_num,"</p>", sep = "")
    table1::table1(formula, data = df, droplevels = FALSE, overall=FALSE, render = render, render.strat = render_strat, caption = cap)
  } else if(!rlang::is_missing(caption) && rlang::is_missing(table_num)) {
    cap <- caption
    table1::table1(formula, data = df, droplevels = FALSE, overall=FALSE, render = render, render.strat = render_strat, caption = cap)
  } else {
    table1::table1(formula, data = df, droplevels = FALSE, overall=FALSE, render = render, render.strat = render_strat)
  }
}

#' Create a Table 1
#'
#' This function provides a wrapper around \code{furniture::\link[furniture:table1]{table1}} that allows it to
#' utilize \code{Hmisc::\link[Hmisc:label]{label}} as variable labels. It also automatically converts logicals
#' to factors so logical dataframe columns are included in the table.
#'
#' @param df a dataframe
#' @param ... a list of columns to be included in the table
#' @param group a group to split the columns by
#' @param neg_label label of the negative `group`
#' @param pos_label label of the positive `group`
#' @inheritParams furniture::table1
#'
#' @return a table; the output varies based on the `output` parameter.
#'
#' @export
#'
#' @examples
#' diamonds <- ggplot2::diamonds
#' diamonds$expensive <- diamonds$price > 500
#' Hmisc::label(diamonds$depth) <- "Depth"
#' Hmisc::label(diamonds$table) <- "Table"
#' Hmisc::label(diamonds$price) <- "Price"
#' Hmisc::label(diamonds$clarity) <- "Clarity"
#' Hmisc::label(diamonds$cut) <- "Cut"
#' Hmisc::label(diamonds$expensive) <- "Expensive"
#' diamonds %>% tableone(depth, table, price, clarity, expensive, group = cut)
#'
#'
tableone <- function(df, ..., group = NULL, neg_label = "No", pos_label = "Yes", test = TRUE, caption = NULL, output = "text", type = c("pvalues", "simple", "condensed")) {
 args <- rlang::ensyms(...)
 group <- rlang::enexpr(group)

 change_to_factor <- function(col) {
   label <- Hmisc::label(col)
   col <- factor(col, levels = c(FALSE, TRUE), labels = c(neg_label, pos_label))
   Hmisc::label(col) <- label
   return(col)
 }

 var_names <- function(df, ...) {
   Hmisc::label(dplyr::select(df, ...))
 }

  if(!is.null(group)) {
    df <- df %>%
      dplyr::select(!!!args, !!group) %>%
      dplyr::mutate(dplyr::across(where(is.logical), ~change_to_factor(.x)))
    rlang::eval_tidy(rlang::quo(furniture::table1(df, !!!args, splitby = ~!!group, test = test, output = output, type = type, caption = caption, var_names = var_names(df, !!!args))))
  } else {
    df <- df %>% dplyr::select(!!!args) %>% dplyr::mutate(dplyr::across(where(is.logical), ~change_to_factor(.x)))
    rlang::eval_tidy(rlang::quo(furniture::table1(df, !!!args, output = output, type = type, caption = caption, var_names = var_names(df, !!!args))))
  }
}

