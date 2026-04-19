#' Fast computation of S-AnthropoAge
#'
#' @param Age Numeric vector of age in years
#' @param Sex Character vector ("Men", "Women")
#' @param Height Numeric vector (meters)
#' @param Weight Numeric vector (kg)
#' @param Waist Numeric vector (cm)
#' @param Ethnicity Character vector
#'
#' @return Numeric vector of S-AnthropoAge
#' @export

s_anthropoage_fast <- function(Age, Sex, Height, Weight, Waist, Ethnicity) {

  if (!all(Sex %in% c("Men", "Women"))) {
    stop("Sex must be 'Men' or 'Women'", call. = FALSE)
  }

  n <- length(Age)
  if (!all(lengths(list(Sex, Height, Weight, Waist, Ethnicity)) == n)) {
    stop("All inputs must have same length", call. = FALSE)
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

  pred <- numeric(n)

  if (any(is_women)) {
    pF <- predict(gomp1aF1,
                  newdata = x[is_women, ],
                  type = "survival",
                  ci = FALSE,
                  times = 120)
    pred[is_women] <- 1 - as.numeric(pF$.pred)
  }

  if (any(is_men)) {
    pM <- predict(gomp1aM1,
                  newdata = x[is_men, ],
                  type = "survival",
                  ci = FALSE,
                  times = 120)
    pred[is_men] <- 1 - as.numeric(pM$.pred)
  }

  output <- numeric(n)

  output[is_women] <- (log(-sW1 * log(1 - pred[is_women])) - b0W1) / b1W1
  output[is_men]   <- (log(-sM1 * log(1 - pred[is_men])) - b0M1) / b1M1

  output[is.infinite(output)] <- NA_real_

  return(output)
}
