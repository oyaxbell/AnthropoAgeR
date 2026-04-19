#' Calculate PhenoAge
#'
#' @description Computes Phenotypic Age (PhenoAge) using clinical biomarkers.
#'
#' @param Age Numeric vector
#' @param CRP C-reactive protein
#' @param Lymph Lymphocyte percentage
#' @param WBC White blood cell count
#' @param Glu Glucose (mg/dL)
#' @param RCDW Red cell distribution width
#' @param Alb Albumin
#' @param Cr Creatinine (mg/dL)
#' @param MCV Mean corpuscular volume
#' @param AP Alkaline phosphatase
#'
#' @return Numeric vector
#' @export
phenoage <- function(Age, CRP, Lymph, WBC, Glu, RCDW, Alb, Cr, MCV, AP) {

  n <- length(Age)
  if (!all(lengths(list(CRP, Lymph, WBC, Glu, RCDW, Alb, Cr, MCV, AP)) == n)) {
    stop("All inputs must have the same length", call. = FALSE)
  }

  if (any(CRP <= 0, na.rm = TRUE)) {
    stop("CRP must be > 0", call. = FALSE)
  }

  Cr  <- Cr * 88.42   # mg/dL → µmol/L
  Glu <- Glu / 18     # mg/dL → mmol/L

  xb <- -19.907 -
    0.0336 * Alb +
    0.0095 * Cr +
    0.1953 * Glu +
    0.0954 * log(CRP) -
    0.0120 * Lymph +
    0.0268 * MCV +
    0.3306 * RCDW +
    0.00188 * AP +
    0.0554 * WBC +
    0.0804 * Age

  m <- 1 - exp(-1.51714 * exp(xb))

  pheno <- 141.5 + log(-0.00553 * log(1 - m)) / 0.09165

  pheno[is.infinite(pheno)] <- NA_real_

  return(pheno)
}
