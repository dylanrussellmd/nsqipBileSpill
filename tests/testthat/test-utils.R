testthat::test_that("get_percent works", {
  testthat::expect_equal(get_percent(mtcars$hp > 150),
               40.625)
})

testthat::test_that("avg works", {
  testthat::expect_equal(avg(c(10,10,10,NA)),
                         10)
})

testthat::test_that("bmi works", {
  testthat::expect_equal(round(bmi(72, 180), digits = 5),
                         24.40972)
})

testthat::test_that("odds_ratio works", {
  df <- data.frame(poison = c(TRUE, TRUE, FALSE, FALSE), death = c(TRUE, FALSE, TRUE, FALSE))
  testthat::expect_equal(df %>% odds_ratio(poison, death) %>% names(),
                         c("data","measure","p.value","correction"))
})
