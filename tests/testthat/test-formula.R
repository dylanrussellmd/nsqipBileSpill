testthat::test_that("make_formula works", {
  testthat::expect_s3_class(make_formula(var1, var2, var3), "formula")
  testthat::expect_type(make_formula(var1, var2, var3), "language")
  testthat::expect_equal(make_formula(var1, var2, var3) %>% as.character(),
                         c("~", "var1", "var2 + var3"))
  testthat::expect_equal(make_formula(var1, var2, var3, lhs = FALSE) %>% as.character(),
                         c("~", "var1 + var2 + var3"))
  testthat::expect_equal(make_formula(var1, var2, var3, group = var4) %>% as.character(),
                         c("~", "var1", "var2 + var3 | var4"))
  testthat::expect_equal(make_formula(var1, var2, var3, op = "*") %>% as.character(),
                         c("~", "var1", "var2 * var3"))
  testthat::expect_equal(make_formula(var1) %>% as.character(),
                         c("~", "var1", "1"))
})

