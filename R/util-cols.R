#' Add BMI column
#'
#' Calculates a BMI from `height` and `weight` and binds an additional column to the supplied data frame.
#'
#' @param df a data frame containing a `height` and `weight` column.
#'
#' @return a data frame
#'
#' @export
#'
#' @examples
#' df <- data.frame(height = c(70, 72, 64), weight = c(150, 160, 170))
#' df <- df %>% add_bmi()
#'
add_bmi <- function(df) {
  df %>% dplyr::mutate(
    bmi = bmi(height, weight)
  ) %>% assign_label(bmi)
}

#' Add preoperatively independent column
#'
#' Creates a column that indicates if a patient is preoperatively functionally independent or not.
#'
#' @param df a data frame containing a `fnstatus2` column.
#'
#' @return a data frame
#'
#' @export
#'
#' @examples
#' df <- data.frame(fnstatus2 = c(1, 2, 3))
#' df <- df %>% add_preopindependent()
#'
add_preopindependent <- function(df) {
  df %>% dplyr::mutate(
    preopindependent = fnstatus2 == 1
  ) %>% assign_label(preopindependent)
}

#' Add postoperatively independent column
#'
#' Creates a column that indicates if a patient is post-operatively functionally independent or not.
#'
#' @param df a data frame containing a `fnstatus1` column.
#'
#' @return a data frame
#'
#' @export
#'
#' @examples
#' df <- data.frame(fnstatus1 = c(1, 2, 3))
#' df <- df %>% add_postopindependent()
#'
add_postopindependent <- function(df) {
  df %>% dplyr::mutate(
    postopindependent = fnstatus1 == 1
  ) %>% assign_label(postopindependent)
}


#' Add Clavien-Dindo classification column
#'
#' Determines a Clavien-Dindo classification from post-operative complication columns and binds an additional column to the supplied data frame.
#'
#' @param df a data frame containing any post-operative complication columns.
#'
#' @return a data frame
#'
#' @importFrom rlang .data
#'
#' @export
#'
#' @examples
#' supinfec <- c(TRUE, FALSE, FALSE)
#' returnor <- c(FALSE, TRUE, FALSE)
#' othseshock <- c(FALSE, FALSE, TRUE)
#' df <- data.frame(supinfec, returnor, othseshock)
#" df <- df %>% add_dindo()
#'
add_dindo <- function(df) {
  df %>% dplyr::mutate(
    dindo = factor(nsqipr::dindo(.))
  ) %>% assign_label(dindo)
}

#' Add a Dindo-Clavien Classification Group
#'
#' Determines a Clavien-Dindo classification group from post-operative complication columns and binds an additional column to the supplied data frame.
#'
#' @inheritParams add_dindo
#'
#' @details Classifies Dindo-Clavien classification groups 1 and 2 as "minor" and groups 3 and above as "major".
#'
#' @importFrom rlang .data
#'
#' @export
#'
#' @importFrom nsqipr dindo
#'
#' @examples
#' supinfec <- c(TRUE, FALSE, FALSE)
#' returnor <- c(FALSE, TRUE, FALSE)
#' othseshock <- c(FALSE, FALSE, TRUE)
#' df <- data.frame(supinfec, returnor, othseshock)
#' df <- df %>% add_dindo_group()
#'
add_dindo_group <- function(df) {
  df %>%
    dplyr::mutate(
      dindo = factor(nsqipr::dindo(.)),
      dindo_min = (dindo == 1 | dindo == 2),
      dindo_maj = (dindo == 3 | dindo == 4 | dindo == 5)
      ) %>%
    assign_label(dindo) %>%
    assign_label(dindo_min) %>%
    assign_label(dindo_maj)
}

#' Remove records with missing values
#'
#' Removes all records from the specified columns that have missing values via filtering for records by `!is.na()`.
#'
#' @param df a dataframe
#' @param ... columns to check for missing values
#'
#' @return a dataframe
#'
#' @export
#'
#' @examples
#' df <- data.frame(a = c(1, 2, NA), b = c(3, NA, 4), c = c(NA, NA, NA))
#' df %>% remove_missing(a, b)
#'
remove_missing <- function(df, ...) {
  cols <- rlang::ensyms(...)
  df %>% dplyr::filter(dplyr::across(.cols = c(!!!cols), ~!is.na(.x)))
}

#' Select a cell from a dataframe given a row and a column
#'
#' Given a row (identified by row names or a character column called "rowname"), select the cell that intersects with a given column.
#'
#' @param df a dataframe
#' @param rowname the name (or id) of a row
#' @param col the name of a column
#' @param percent return value multiplied by 100
#'
#' @details This function requires a data frame either have row names, a column called "rowname", or that a row be referred to by its ID if neither of the previous conditions are true.
#' `percent` is useful for returning numeric values reported as rates that you would like reported as percentages.
#'
#' @return a single cell from a data frame that is of the class of the value's containing column
#'
#' @export
#'
#' @examples pull_cell(mtcars, `Mazda RX4`, mpg, percent = FALSE)
#'
pull_cell <- function(df, rowname, col, percent = FALSE) {
  rowname <- rlang::enquo(rowname)
  row_str <- rlang::as_name(rowname)
  col <- rlang::enquo(col)

  if("rowname" %nin% colnames(df)){
    if(tibble::has_rownames(df)) {
      df <- df %>% tibble::rownames_to_column()
    } else {
      df <- df %>% tibble::rowid_to_column(var = "rowname")
    }
  }

  val <- df %>%
    dplyr::filter(rowname == row_str) %>%
    dplyr::pull(!!col)

  if(percent) {val*100} else {val}
}
