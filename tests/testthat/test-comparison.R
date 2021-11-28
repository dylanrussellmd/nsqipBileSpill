testthat::test_that("comparison works", {
  testthat::expect_equal(mtcars %>% dplyr::group_by(hp > 150) %>% dplyr::ungroup() %>% comparison(`hp > 150`, am) %>% class(),
                         c("tbl_df","tbl","data.frame"))
  testthat::expect_equal(mtcars %>% dplyr::group_by(hp > 150) %>% dplyr::ungroup() %>% comparison(`hp > 150`, am) %>% dplyr::pull("method"),
                        "Welch Two Sample t-test")
  testthat::expect_equal(mtcars %>% dplyr::group_by(hp > 150) %>% dplyr::ungroup() %>% dplyr::mutate(mpg > 20) %>% comparison(`hp > 150`, `mpg > 20`) %>% dplyr::pull("method"),
                         "Pearson's Chi-squared test with Yates' continuity correction")
  testthat::expect_equal(mtcars %>% dplyr::group_by(hp > 150) %>% dplyr::ungroup() %>% dplyr::mutate(mpg > 20) %>% comparison(`hp > 150`, `mpg > 20`, am) %>% colnames(),
                         c("rowname", "hp > 150_false", "hp > 150_true", "p.value", "method"))
  testthat::expect_equal(mtcars %>% dplyr::group_by(hp > 150) %>% dplyr::ungroup() %>% comparison(`hp > 150`, mpg, am) %>% dplyr::pull("rowname"),
                         c("mpg","am"))
  testthat::expect_error(mtcars %>% comparison(hp, am, mpg), "group should be a logical vector")
})


testthat::test_that("choose_test works", {
  testthat::expect_equal(mtcars %>% dplyr::group_by(hp > 150) %>% choose_test(`hp > 150`, mpg) %>% .$method,
                         "Welch Two Sample t-test")
  testthat::expect_equal(mtcars %>% dplyr::group_by(hp > 150) %>% dplyr::mutate(mpg > 20) %>% choose_test(`hp > 150`, `mpg > 20`) %>% .$method,
                         "Pearson's Chi-squared test with Yates' continuity correction")
  testthat::expect_error(mtcars %>% choose_test(hp, am), "group should be a logical vector")
  testthat::expect_error(mtcars %>% dplyr::group_by(hp > 150) %>% dplyr::mutate(gear = factor(gear)) %>% choose_test(`hp > 150`, gear),
                         "Can not apply either chi-square or t.test to column gear")
})
