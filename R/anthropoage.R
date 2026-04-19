#' Calculate AnthropoAge
#'
#' @description Computes AnthropoAge as a proxy of biological age using
#' anthropometric variables, age, sex and ethnicity.
#'
#' @param Age Numeric vector
#' @param Sex Character vector ("Men", "Women")
#' @param Ethnicity Character vector ("White", "Black", "Mexican-American", "Other")
#' @param Height Numeric (meters)
#' @param Weight Numeric (kg)
#' @param Waist Numeric
#' @param Subscapular_skinfold Numeric (optional)
#' @param Triceps_skinfold Numeric (optional)
#' @param Thigh_circumference Numeric (optional)
#' @param Arm_circumference Numeric (optional)
#'
#' @return Numeric vector of AnthropoAge
#' @export
#' @importFrom stats predict coef

anthropoage <- function(Age, Sex, Ethnicity, Height, Weight, Waist,
                        Subscapular_skinfold = 1,
                        Triceps_skinfold = 1,
                        Thigh_circumference = 1,
                        Arm_circumference = 1) {

  BMI <- Weight / (Height^2)
  ICE <- Waist / (Height * 100)

  x <- data.frame(
    Age = Age,
    Sex = Sex,
    Ethnicity = Ethnicity,
    tr_imc = log(BMI),
    tr_ice = ICE^(1/3),
    tr_weight = log(Weight),
    tr_subs = Subscapular_skinfold^(1/3),
    tr_tric = Triceps_skinfold^(1/3),
    tr_height = Height^(1/3),
    tr_armc = sqrt(Arm_circumference),
    tr_thigh = log(Thigh_circumference)
  )

  sM <- 1 / ((exp(coef(gomp1bM)[1] * 120) - 1) / coef(gomp1bM)[1])
  b0M <- coef(gomp1bM)[2]
  b1M <- coef(gomp1bM)[3]

  sW <- 1 / ((exp(coef(gomp1bF)[1] * 120) - 1) / coef(gomp1bF)[1])
  b0W <- coef(gomp1bF)[2]
  b1W <- coef(gomp1bF)[3]

  is_women <- Sex == "Women"
  is_men   <- Sex == "Men"

  pred <- numeric(nrow(x))

  if (any(is_women)) {
    pF <- predict(gomp1aF,
                  newdata = x[is_women, ],
                  type = "survival",
                  ci = FALSE,
                  times = 120)
    pred[is_women] <- 1 - as.numeric(pF$.pred)
  }

  if (any(is_men)) {
    pM <- predict(gomp1aM,
                  newdata = x[is_men, ],
                  type = "survival",
                  ci = FALSE,
                  times = 120)
    pred[is_men] <- 1 - as.numeric(pM$.pred)
  }

  output <- numeric(length(pred))

  output[is_women] <- (log(-sW * log(1 - pred[is_women])) - b0W) / b1W
  output[is_men]   <- (log(-sM * log(1 - pred[is_men])) - b0M) / b1M

  output[is.infinite(output)] <- NA_real_

  return(output)
}
