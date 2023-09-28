#' @author Ranadeep Daw and Eva Marques
#' @description
#' unit testing: is the model output netcdf?
#' 
#'

test_that("the model output is netcdf", {
  library(ncdf4)

  # the test is running on the object named "output"
  expect_is(model.output, 'ncdf4')
})
