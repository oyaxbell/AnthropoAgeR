rename_tidy <- function(x) {
  names_map <- c(
    time = ".time",
    quantile = ".quantile",
    est = ".pred",
    se = ".std_error",
    lcl = ".pred_lower",
    ucl = ".pred_upper")

  lapply(x, function(df) {
    idx <- match(names(df), names_map)
    names(df)[!is.na(idx)] <- names_map[idx[!is.na(idx)]]
    df
  })
}

#' Predict method for flexsurvreg models (tidy output)
#'
#' @description
#' A wrapper around summary() for flexsurv models that returns
#' tidy outputs with standardized column names.
#'
#' @param object A flexsurvreg model object.
#' @param newdata Data frame for prediction.
#' @param type Type of prediction.
#' @param times Optional time points.
#' @param conf.int Logical; compute confidence intervals.
#' @param conf.level Confidence level.
#' @param se.fit Logical; compute standard errors.
#' @param p Quantiles for prediction.
#' @param ... Additional arguments passed to summary().
#'
#' @return A data frame with predictions.
#'
#' @exportS3Method predict flexsurvreg
#' @importFrom stats predict
#' @importFrom stats predict model.frame
predict.flexsurvreg <- function(object,
                                newdata,
                                type = "response",
                                times,
                                conf.int = FALSE,
                                conf.level = 0.95,
                                se.fit = FALSE,
                                p = c(0.1, 0.9),
                                ...)
{
  if (missing(newdata)) newdata <- model.frame(object)

  assertthat::assert_that(inherits(newdata, "data.frame"))
  assertthat::assert_that(is.logical(conf.int), is.logical(se.fit))
  assertthat::assert_that(all(is.numeric(p), p <= 1, p >= 0))

  if (conf.int) {
    assertthat::assert_that(is.numeric(conf.level),
                            conf.level > 0, conf.level < 1,
                            length(conf.level) == 1)
  }

  type <- match.arg(type, c("response", "quantile", "link", "lp", "linear",
                            "survival", "cumhaz", "hazard", "rmst"))

  stype <- switch(
    type,
    response = "mean",
    lp = "link",
    linear = "link",
    type
  )

  if (stype %in% c("survival", "cumhaz", "hazard")) {
    if (missing(times)) times <- object$data$Y[, 1][order(object$data$Y[, 1])]
    assertthat::assert_that(all(is.numeric(times), times > 0))
  } else if (stype == "rmst" && !missing(times)) {
    assertthat::assert_that(all(is.numeric(times), times > 0))
  } else {
    times <- NULL
  }

  nest_output <- ((stype == "quantile" && length(p) > 1) |
                    (stype %in% c("survival", "cumhaz", "hazard", "rmst") &&
                       length(times) > 1))

 res <- summary(
   object = object,
   newdata = newdata,
   type = stype,
   quantiles = p,
   t = times,
   ci = conf.int,
   cl = conf.level,
   se = se.fit,
   tidy = FALSE,
   ...)

  res <- rename_tidy(unname(res))

  res <- tibble::tibble(.pred = res)

  if (!nest_output) {
    res <- tidyr::unnest(res, ".pred")
  }

  res
}
