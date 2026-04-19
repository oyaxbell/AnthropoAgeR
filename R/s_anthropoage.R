#' Calculate Simplified AnthropoAge (S-AnthropoAge)
#'
#' @description Computes S-AnthropoAge as a proxy of biological age using
#' anthropometric variables, age, sex and ethnicity.
#'
#' @param Age Numeric vector
#' @param Sex Character vector ("Men", "Women")
#' @param Height Numeric (meters)
#' @param Weight Numeric (kg)
#' @param Waist Numeric
#' @param Ethnicity Character vector ("White", "Black", "Mexican-American", "Other")
#'
#' @return Numeric vector
#' @export
#' @importFrom stats predict coef

s_anthropoage <- function(Age, Sex, Height, Weight, Waist, Ethnicity) {

  if (!all(Sex %in% c("Men", "Women"))) {
    stop("Sex must be 'Men' or 'Women'", call. = FALSE)
  }

  if (!is.numeric(Age)) stop("Age must be numeric")

  n <- length(Age)
  if (!all(lengths(list(Sex, Height, Weight, Waist, Ethnicity)) == n)) {
    stop("All inputs must have same length")
  }

  BMI <- Weight / (Height^2)
  ICE <- Waist / (Height * 100)

  x <- data.frame(
    Age = Age,
    Sex = Sex,
    tr_imc = log(BMI),
    tr_ice = ICE^(1/3),
    Ethnicity = Ethnicity
  )

  sM1 <- 1 / ((exp(coef(gomp1bM1)[1] * 120) - 1) / coef(gomp1bM1)[1])
  b0M1 <- coef(gomp1bM1)[2]
  b1M1 <- coef(gomp1bM1)[3]

  sW1 <- 1 / ((exp(coef(gomp1bF1)[1] * 120) - 1) / coef(gomp1bF1)[1])
  b0W1 <- coef(gomp1bF1)[2]
  b1W1 <- coef(gomp1bF1)[3]

  is_women <- Sex == "Women"
  is_men   <- Sex == "Men"

  pred <- numeric(nrow(x))

  if (any(is_women)) {
    pF <- predict(
      gomp1aF1,
      newdata = x[is_women, ],
      type = "survival",
      ci = FALSE,
      times = 120
    )
    pred[is_women] <- 1 - as.numeric(pF$.pred)
  }

  if (any(is_men)) {
    pM <- predict(
      gomp1aM1,
      newdata = x[is_men, ],
      type = "survival",
      ci = FALSE,
      times = 120
    )
    pred[is_men] <- 1 - as.numeric(pM$.pred)
  }

  output <- numeric(length(pred))

  output[is_women] <- (log(-sW1 * log(1 - pred[is_women])) - b0W1) / b1W1
  output[is_men]   <- (log(-sM1 * log(1 - pred[is_men])) - b0M1) / b1M1

  output[is.infinite(output)] <- NA_real_

  return(output)
}
