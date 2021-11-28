#' Fetch a label
#'
#' Fetches a character vector to be used as a label for a column from a pre-determined list of labels.
#'
#' @param col a string representing a column name from a dataframe
#'
#' @return a character vector
#'
#' @export
#'
#' @examples fetch_label("age")
#'
fetch_label <- function(col) {
  val <- c("sex" = "Male",
           "age" = "Age",
           "height" = "Height",
           "weight" = "Weight",
           "bmi" = "BMI",
           "diabetes" = "Diabetic with oral agents or insulin",
           "smoke" = "Current smoker within 1 year",
           "dyspnea" = "Pre-operative dyspnea",
           "when_dypsnea" = "Onset of dyspnea",
           "fnstatus2" = "Functionally dependent preoperatively",
           "preopindependent" = "Functionally independent preoperatively",
           "postopindependent" = "Functionally independent postoperatively",
           "hxcopd" = "History of severe COPD",
           "ascites" = "Ascites within 30 days of surgery",
           "hxchf" = "History of CHF within 30 days of surgery",
           "hypermed" = "Hypertension requiring medication",
           "dialysis" = "Currently requiring or on dialysis",
           "discancr" = "Disseminated cancer",
           "steroid" = "Steroid/immunosuppresant use for chronic condition",
           "wtloss" = ">10% weight loss in last 6 months",
           "bleeddis" = "Bleeding disorders",
           "optime" = "Operative time (minutes)",
           "supinfec" = "Superficial SSI",
           "wndinfd" = "Deep SSI",
           "orgspcssi" = "Organ-space SSI",
           "yrdeath" = "Year of death",
           "tothlos" = "Length of stay (days)",
           "dindo" = "Clavien-Dindo classification",
           "dindo_min" = "Minor complication (Clavien-Dindo 1 or 2)",
           "dindo_maj" = "Major complication (Clavien-Dindo 3 or higher)",
           "insulin" = "Diabetic requiring insulin",
           "ioc" = "Intraoperative cholangiogram",
           "mort" = "Death within 30 days of surgery")
  unname(val[col])
}

#' Assign a label to a column
#'
#' Assigns a label to a data frame column using \code{Hmisc::\link[Hmisc:label]{label()}}
#'
#' @param df a data frame
#' @param col a column
#'
#' @details Fetches label from \code{nsqipBileSpill::\link[nsqipBileSpill:fetch_label]{fetch_label()}}.
#'
#' @return A dataframe with the new labels
#'
#' @details In order to ascribe your own labels, you must update the \code{nsqipBileSpill::\link[nsqipBileSpill:fetch_label]{fetch_label()}} function.
#'
#' @export
#'
#' @examples
#' df <- data.frame(age = c(1,2,3))
#' df %>% assign_label(age)
#'
assign_label <- function(df, col) {
  col <- rlang::as_name(rlang::ensym(col))
  Hmisc::label(df[[col]]) <- fetch_label(col)
  return(df)
}

#' Assign labels to a data frame
#'
#' Assigns labels to data frame columns using \code{Hmisc::\link[Hmisc:label]{label()}}
#'
#' @param df a data frame
#'
#' @details Fetches labels from \code{nsqipBileSpill::\link[nsqipBileSpill:fetch_label]{fetch_label()}}.
#'
#' @return A dataframe with the new labels
#'
#' @details In order to ascribe your own labels, you must update the \code{nsqipBileSpill::\link[nsqipBileSpill:fetch_label]{fetch_label()}} function.
#'
#' @export
#'
#' @examples
#' df <- data.frame(age = c(25, 32, 47), height = c(72, 65, 70), weight = c(180, 210, 190))
#' df %>% assign_labels()
#'
assign_labels <- function(df) {
  purrr::iwalk(df, function(.x, .y) {
    lab <- fetch_label(.y)
    Hmisc::label(df[[.y]]) <<- lab
  })
  return(df)
}



