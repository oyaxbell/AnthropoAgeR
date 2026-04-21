utils::globalVariables("idx")

#' Fast computation of S-AnthropoAge
#'
#' @description Computes S-AnthropoAge as a proxy of biological age using
#' anthropometric variables, age, sex and ethnicity using a parallel
#' computing approach. Recommended only for sample sizes n > 1,000.
#'
#' @param Age Numeric vector of age in years
#' @param Sex Character vector ("Men", "Women")
#' @param Height Numeric vector (meters)
#' @param Weight Numeric vector (kg)
#' @param Waist Numeric vector (cm)
#' @param Ethnicity Character vector ("White", "Black", "Mexican-American", "Other")
#'
#' @return Numeric vector of S-AnthropoAge
#' @importFrom foreach foreach %dopar%
#' @importFrom parallel detectCores makeCluster stopCluster clusterExport
#' @importFrom utils globalVariables
#' @export

s_anthropoage_fast <- function(Age, Sex, Height, Weight, Waist, Ethnicity) {

  #Requires
  #doParallel
  #parallel

  #Labels for the sex variable
  if (!all(Sex %in% c("Men", "Women"))) {
    stop("Sex must be 'Men' or 'Women'", call. = FALSE)
  }

  #All variables have the same length
  n <- length(Age)
  if (!all(lengths(list(Sex, Height, Weight, Waist, Ethnicity)) == n)) {
    stop("All inputs must have same length", call. = FALSE)
  }

  #Calculate BMI and WHtR
  BMI <- Weight / (Height^2)
  ICE <- Waist / (Height * 100)

  #Create dataset
  x <- data.frame(
    Age = Age,
    Sex = Sex,
    tr_imc = log(BMI), #Transformed BMI (log)
    tr_ice = ICE^(1/3), #Transformed WHtR (cubic root)
    Ethnicity = Ethnicity
  )

  #Fixed coefficients for women
  sW1 <- 1 / ((exp(coef(gomp1bF1)[1] * 120) - 1) / coef(gomp1bF1)[1])
  b0W1 <- coef(gomp1bF1)[2]
  b1W1 <- coef(gomp1bF1)[3]

  #Fixed coefficients for men
  sM1 <- 1 / ((exp(coef(gomp1bM1)[1] * 120) - 1) / coef(gomp1bM1)[1])
  b0M1 <- coef(gomp1bM1)[2]
  b1M1 <- coef(gomp1bM1)[3]

  #Women data
  is_women <- Sex == "Women"
  x_w <- x[is_women, ]

  #Men data
  is_men   <- Sex == "Men"
  x_m <- x[is_men, ]

  #Empty prediction and output
  pred <- numeric(n)
  output <- numeric(n)

  #Set chunk size depending on sample size
  if(n>=2000){chunk_size <- 1000}
  else{chunk_size <- 100}

  #Parallel implementation
  use_parallel <- n >= 500

  if (use_parallel) {

    ncores <- max(1, parallel::detectCores() - 1)
    cl <- parallel::makeCluster(ncores)
    doParallel::registerDoParallel(cl)

    on.exit(parallel::stopCluster(cl), add = TRUE)

    # Export needed objects to workers
    parallel::clusterExport(
      cl,
      varlist = c("gomp1aF1", "gomp1aM1"),
      envir = environment()
    )
  }

  #Parallel prediction in women
  if (nrow(x_w) > 0) {
    pF <- foreach::foreach(
      idx = seq(1, nrow(x_w), by = chunk_size),
      .combine = rbind) %dopar% {
        predict(gomp1aF1,
                newdata = x_w[idx:min(idx+chunk_size-1, nrow(x_w)), ],
                type = "survival",
                ci = FALSE,
                times = 120)
      }
  }

  #Parallel prediction in men
  if (nrow(x_m) > 0) {
    pM <- foreach::foreach(
      idx = seq(1, nrow(x_m), by = chunk_size),
      .combine = rbind) %dopar% {
        predict(gomp1aM1,
                newdata = x_m[idx:min(idx+chunk_size-1, nrow(x_m)), ],
                type = "survival",
                ci = FALSE,
                times = 120)
      }
  }

  #Gompertz survival predictions
  pred[is_women] <- 1 - as.numeric(pF$.pred)
  pred[is_men] <- 1 - as.numeric(pM$.pred)

  #AnthropoAge
  output[is_women] <- (log(-sW1 * log(1 - pred[is_women])) - b0W1) / b1W1
  output[is_men] <- (log(-sM1 * log(1 - pred[is_men])) - b0M1) / b1M1
  output[is.infinite(output)] <- NA_real_

  return(output)
}

