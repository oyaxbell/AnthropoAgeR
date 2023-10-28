\name{predict.flexsurvreg}
\alias{predict.flexsurvreg}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Function to use predict in flexsurvreg objects
}
\description{
Function to use predict in flexsurvreg objects
}
\usage{
predict.flexsurvreg(object, newdata, type = "response", times, conf.int = FALSE, conf.level = 0.95, se.fit = FALSE, p = c(0.1, 0.9), ...)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{object}{
%%     ~~Describe \code{object} here~~
}
  \item{newdata}{
%%     ~~Describe \code{newdata} here~~
}
  \item{type}{
%%     ~~Describe \code{type} here~~
}
  \item{times}{
%%     ~~Describe \code{times} here~~
}
  \item{conf.int}{
%%     ~~Describe \code{conf.int} here~~
}
  \item{conf.level}{
%%     ~~Describe \code{conf.level} here~~
}
  \item{se.fit}{
%%     ~~Describe \code{se.fit} here~~
}
  \item{p}{
%%     ~~Describe \code{p} here~~
}
  \item{\dots}{
%%     ~~Describe \code{\dots} here~~
}
}
\details{
%%  ~~ If necessary, more details than the description above ~~
}
\value{
%%  ~Describe the value returned
%%  If it is a LIST, use
%%  \item{comp1 }{Description of 'comp1'}
%%  \item{comp2 }{Description of 'comp2'}
%% ...
}
\references{
%% ~put references to the literature/web site here ~
}
\author{
%%  ~~who you are~~
}
\note{
%%  ~~further notes~~
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
%% ~~objects to See Also as \code{\link{help}}, ~~~
}
\examples{
##---- Should be DIRECTLY executable !! ----
##-- ==>  Define data, use random,
##--	or do  help(data=index)  for the standard data sets.

## The function is currently defined as
function (object, newdata, type = "response", times, conf.int = FALSE,
    conf.level = 0.95, se.fit = FALSE, p = c(0.1, 0.9), ...)
{
    if (missing(newdata))
        newdata <- model.frame(object)
    assertthat::assert_that(inherits(newdata, "data.frame"),
        msg = "`newdata` must inherit class `data.frame`")
    assertthat::assert_that(is.logical(conf.int), is.logical(se.fit))
    assertthat::assert_that(all(is.numeric(p), p <= 1, p >= 0),
        msg = "`p` should be a vector of quantiles between 0 and 1")
    if (conf.int)
        assertthat::assert_that(is.numeric(conf.level), conf.level >
            0, conf.level < 1, length(conf.level) == 1, msg = "`conf.level` must be length one and between 0 and 1")
    type <- match.arg(type, c("response", "quantile", "link",
        "lp", "linear", "survival", "cumhaz", "hazard", "rmst"))
    stype <- switch(type, response = "mean", lp = "link", linear = "link",
        type)
    if (stype \%in\% c("survival", "cumhaz", "hazard")) {
        if (missing(times))
            times <- object$data$Y[, 1][order(object$data$Y[,
                1])]
        assertthat::assert_that(all(is.numeric(times), times >
            0), msg = "`times` must be a vector of positive real-valued numbers.")
    }
    else if (stype == "rmst" && !missing(times)) {
        assertthat::assert_that(all(is.numeric(times), times >
            0), msg = "`times` must be a vector of positive real-valued numbers.")
    }
    else {
        times <- NULL
    }
    nest_output <- ((stype == "quantile" && length(p) > 1) |
        (stype \%in\% c("survival", "cumhaz", "hazard", "rmst") &&
            length(times) > 1))
    res <- summary(object = object, newdata = newdata, type = stype,
        quantiles = p, t = times, ci = conf.int, cl = conf.level,
        se = se.fit, tidy = FALSE)
    res <- rename_tidy(unname(res))
    res <- tibble::tibble(.pred = res)
    if (!nest_output) {
        res <- tidyr::unnest(res, .pred)
    }
    res
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory (show via RShowDoc("KEYWORDS")):
% \keyword{ ~kwd1 }
% \keyword{ ~kwd2 }
% Use only one keyword per line.
% For non-standard keywords, use \concept instead of \keyword:
% \concept{ ~cpt1 }
% \concept{ ~cpt2 }
% Use only one concept per line.
