testthat::test_that("A bmi column is added correctly", {
  df <- data.frame(height = c(70, 72, 64), weight = c(150, 160, 170)) %>% add_bmi()
  testthat::expect_equal(df %>% colnames(),
                         c("height","weight","bmi"))
  testthat::expect_equal(df %>% Hmisc::label() %>% as.character(),
                         c("","","BMI"))
})

testthat::test_that("A preopindependent column is added correctly", {
  df <- data.frame(fnstatus2 = c(1, 2, 3)) %>% add_preopindependent()
  testthat::expect_equal(df %>% colnames(),
                         c("fnstatus2","preopindependent"))
  testthat::expect_equal(df %>% Hmisc::label() %>% as.character(),
                         c("","Functionally independent preoperatively"))
  testthat::expect_equal(df %>% dplyr::pull(preopindependent) %>% as.logical(),
                         c(TRUE, FALSE, FALSE))
})

testthat::test_that("A postopindependent column is added correctly", {
  df <- data.frame(fnstatus1 = c(1, 2, 3)) %>% add_postopindependent()
  testthat::expect_equal(df %>% colnames(),
                         c("fnstatus1","postopindependent"))
  testthat::expect_equal(df %>% Hmisc::label() %>% as.character(),
                         c("","Functionally independent postoperatively"))
  testthat::expect_equal(df %>% dplyr::pull(postopindependent) %>% as.logical(),
                         c(TRUE, FALSE, FALSE))
})

testthat::test_that("A dindo column is added correctly", {
  df <- data.frame(supinfec = c(TRUE, FALSE, FALSE), returnor = c(FALSE, TRUE, FALSE), othseshock = c(FALSE, FALSE, TRUE)) %>% add_dindo()
  testthat::expect_equal(df %>% colnames(),
                         c("supinfec","returnor","othseshock","dindo"))
  testthat::expect_equal(df %>% Hmisc::label() %>% as.character(),
                         c("","","","Clavien-Dindo classification"))
  testthat::expect_s3_class(df %>% dplyr::pull(dindo),
                            "factor")
  testthat::expect_equal(df %>% dplyr::pull(dindo) %>% as.character(),
                         c("1", "3", "4"))
})

testthat::test_that("dindo_min and dindo_maj columns are added correctly", {
  df <- data.frame(supinfec = c(TRUE, FALSE, FALSE), returnor = c(FALSE, TRUE, FALSE), othseshock = c(FALSE, FALSE, TRUE)) %>% add_dindo_group()
  testthat::expect_equal(df %>% colnames(),
                         c("supinfec","returnor","othseshock","dindo","dindo_min","dindo_maj"))
  testthat::expect_equal(df %>% Hmisc::label() %>% as.character(),
                         c("","","","Clavien-Dindo classification", "Minor complication (Clavien-Dindo 1 or 2)","Major complication (Clavien-Dindo 3 or higher)"))
  testthat::expect_type(df %>% dplyr::pull(dindo_min),
                            "logical")
  testthat::expect_type(df %>% dplyr::pull(dindo_maj),
                        "logical")
  testthat::expect_equal(df %>% dplyr::pull(dindo_min) %>% as.logical(),
                         c(TRUE, FALSE, FALSE))
  testthat::expect_equal(df %>% dplyr::pull(dindo_maj) %>% as.logical(),
                         c(FALSE, TRUE, TRUE))
})

testthat::test_that("remove_missing works correctly", {
  df <- data.frame(a = c(1, 2, NA), b = c(3, NA, 4), c = c(NA, NA, NA))
  testthat::expect_equal(df %>% remove_missing(a, b),
                         data.frame(a = 1, b = 3, c = NA))
})

testthat::test_that("pull_cell works correctly", {
  testthat::expect_equal(pull_cell(mtcars, "Mazda RX4", mpg, percent = FALSE),
                         21)
  testthat::expect_equal(pull_cell(mtcars, "Cadillac Fleetwood", gear, percent = TRUE),
                         300)
})
