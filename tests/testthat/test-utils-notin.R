testthat::test_that("%nin% works", {
  testthat::expect_true("dog" %nin% c("cat","giraffe","elephant"))
  testthat::expect_false("dog" %nin% c("dog","giraffe","elephant"))
})
