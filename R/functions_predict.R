#' @method

predict.flexsurvreg <- function(object,
                                newdata,
                                type = "response",
                                times,
                                conf.int = FALSE,
                                conf.level = 0.95,
                                se.fit = FALSE,
                                p = c(0.1, 0.9),
                                ...
)
{
  if (missing(newdata)) newdata <- model.frame(object)

  assertthat::assert_that(inherits(newdata, "data.frame"),
                          msg = "`newdata` must inherit class `data.frame`")
  assertthat::assert_that(is.logical(conf.int), is.logical(se.fit))
  assertthat::assert_that(all(is.numeric(p), p <= 1, p >=0),
                          msg = "`p` should be a vector of quantiles between 0 and 1")

  if (conf.int) assertthat::assert_that(is.numeric(conf.level),
                                        conf.level > 0, conf.level < 1,
                                        length(conf.level) == 1,
                                        msg = "`conf.level` must be length one and between 0 and 1")

  type <- match.arg(type, c("response", "quantile", "link", "lp", "linear",
                            "survival", "cumhaz", "hazard", "rmst"))

  stype <- switch(
    type,
    response = "mean",
    lp = "link",
    linear = "link",
    type # all others keep their type
  )

  if (stype %in% c("survival", "cumhaz", "hazard")) {
    if (missing(times)) times <- object$data$Y[, 1][order(object$data$Y[, 1])]
    assertthat::assert_that(all(is.numeric(times), times > 0),
                            msg = "`times` must be a vector of positive real-valued numbers.")
  } else if (stype == "rmst" && !missing(times)) {
    assertthat::assert_that(all(is.numeric(times), times > 0),
                            msg = "`times` must be a vector of positive real-valued numbers.")
  } else {
    times <- NULL
  }

  nest_output <- ((stype == "quantile" && length(p) > 1) |
                    (stype %in% c("survival", "cumhaz", "hazard", "rmst") &&
                       length(times) > 1))

  res <- summary(object = object, newdata = newdata, type = stype,
                 quantiles = p, t = times,
                 ci = conf.int, cl = conf.level, se = se.fit,
                 tidy = FALSE)

  res <- rename_tidy(unname(res))

  res <- tibble::tibble(.pred = res)

  if (!nest_output) {
    res <- tidyr::unnest(res, .pred)
  }
  res
}

rename_tidy <- function(x){
  names_map <- tibble::tibble(
    old_names = c("time", "quantile", "est", "se", "lcl", "ucl"),
    new_names  = c(".time", ".quantile", ".pred",
                   ".std_error", ".pred_lower", ".pred_upper")
  )

  x <- lapply(x, function (x) {
    for (i in seq_along(names_map$old_names)) {
      colnames(x)[colnames(x)==names_map$old_names[i]] <- names_map$new_names[i]
    }
    x
  })
  x
}
