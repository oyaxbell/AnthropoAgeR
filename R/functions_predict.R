rename_tidy <- function(x) {
  names_map <- c(
    time = ".time",
    quantile = ".quantile",
    est = ".pred",
    se = ".std_error",
    lcl = ".pred_lower",
    ucl = ".pred_upper"
  )

  lapply(x, function(df) {
    old <- names(df)
    new <- names_map[old]
    names(df)[!is.na(new)] <- new[!is.na(new)]
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
  if (missing(newdata)) newdata <- stats::model.frame(object)

  type <- match.arg(type, c(
    "response", "quantile", "link", "lp", "linear",
    "survival", "cumhaz", "hazard", "rmst"
  ))

  stype <- switch(type,
                  response = "mean",
                  lp = "link",
                  linear = "link",
                  type
  )

  dots <- list(...)
  dots$ci <- NULL
  dots$cl <- NULL
  dots$se <- NULL

  res <- do.call(
    summary,
    c(list(
      object = object,
      newdata = newdata,
      type = stype,
      quantiles = p,
      t = times,
      ci = conf.int,
      cl = conf.level,
      se = se.fit,
      tidy = FALSE
    ), dots)
  )

  res <- rename_tidy(unname(res))
  res <- tibble::tibble(.pred = res)

  if (!((stype == "quantile" && length(p) > 1))) {
    res <- tidyr::unnest(res, ".pred")
  }

  res
}
