testthat::test_that("fetch_label works", {
  testthat::expect_equal(fetch_label("age"), "Age")
  testthat::expect_equal(fetch_label("bmi"), "BMI")
  testthat::expect_equal(fetch_label("hxcopd"), "History of severe COPD")
})

testthat::test_that("assign_label works", {
  testthat::expect_equal(data.frame(age = c(1,2,3)) %>% assign_label(age) %>% Hmisc::label() %>% as.character(),
                         "Age")
})

testthat::test_that("assign_labels works", {
  testthat::expect_equal(data.frame(age = c(25, 32, 47), height = c(72, 65, 70), weight = c(180, 210, 190)) %>% assign_labels() %>% Hmisc::label() %>% as.character(),
                         c("Age","Height","Weight"))
})

