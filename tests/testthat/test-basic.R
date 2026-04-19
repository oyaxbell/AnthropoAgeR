test_that("anthropoage returns numeric output", {
  res <- anthropoage(
    Age = 50,
    Sex = "Men",
    Ethnicity = "Mexican-American",
    Height = 1.70,
    Weight = 70,
    Waist = 90,
    Subscapular_skinfold = 10,
    Triceps_skinfold = 10,
    Thigh_circumference = 50,
    Arm_circumference = 30
  )

  expect_type(res, "double")
  expect_length(res, 1)
})
