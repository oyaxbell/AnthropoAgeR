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

#' @exportS3Method predict flexsurvreg
#' @importFrom stats predict
predict.flexsurvreg <- function(object,
                                newdata,
                                type = "response",
                                times,
                                conf.int = FALSE,
                                conf.level = 0.95,
                                se.fit = FALSE,
                                p = c(0.1, 0.9),
                                ...
) {
  ...
}
