#' Calculate Age Acceleration
#'
#' @description Computes biological age acceleration as residuals from
#' a linear model of BA ~ Age, stratified by sex.
#'
#' @param Age Numeric vector (chronological age)
#' @param BA Numeric vector (biological age)
#' @param Sex Character vector ("Men", "Women")
#'
#' @return Numeric vector of residuals
#' @export
#' @importFrom stats lm residuals

age_accel <- function(Age, BA, Sex) {

  n <- length(Age)

  if (!all(lengths(list(BA, Sex)) == n)) {
    stop("All inputs must have the same length", call. = FALSE)
  }

  if (!all(Sex %in% c("Men", "Women"))) {
    stop("Sex must be 'Men' or 'Women'", call. = FALSE)
  }

  if (n < 10) {
    warning("Sample size < 10; results may be unstable", call. = FALSE)
  }

  x <- data.frame(Age = Age, BA = BA, Sex = Sex)

  accel <- rep(NA_real_, n)

  idx_w <- Sex == "Women"
  if (any(idx_w)) {
    fit_w <- lm(BA ~ Age, data = x[idx_w, ])
    accel[idx_w] <- residuals(fit_w)
  }

  idx_m <- Sex == "Men"
  if (any(idx_m)) {
    fit_m <- lm(BA ~ Age, data = x[idx_m, ])
    accel[idx_m] <- residuals(fit_m)
  }

  accel[is.infinite(accel)] <- NA_real_

  return(accel)
}
