\name{phenoage}
\alias{phenoage}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Calculate the blood-based PhenoAge biological age measure
}
\description{
phenoage( ) is used to estimate a second-generation biological age measure known as PhenoAge, derived from work by Morgan Levine and collaborators using nine blood biomarkers related to 10-year all-cause mortality. PhenoAge is estimated using chronological age (Age), C-reactive protein (CRP), lymphocite percentage (Lymp), white blood cell count (WBC), red cell distribution width (RCDW), serum albumin (Alb), serum creatinine (Cr), fasting plasma glucose (Glu), mean cell volume (MCV) and alkaline phosphatase (AP). All should be fasting measures.

PhenoAge is interpreted as the estimated 10-year risk of all cause mortality based on blood biomarkers and is a proxy of biological age.
}
\usage{
phenoage(Age, CRP, Lymph, WBC, Glu, RCDW, Alb, Cr, MCV, AP)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{Age}{Chronological age of an individual expressed in full years.}
  \item{CRP}{C-reactive protein}
  \item{Lymph}{Lymphocite percentage of an individual.}
  \item{WBC}{White blood cell count of an individual expressed as per 1,000 U/L}
  \item{Glu}{Fasting plasma glucose of an individual measured in mg/dL.}
  \item{RCDW}{Red cell distribution width of an individual measured in percentage.}
  \item{Alb}{Serum albumin of an individual measured in g/dL.}
  \item{Cr}{Serum creatinine of an individual measured in mg/dL.}
  \item{MCV}{Mean corposcular volume of an individual measured in fL.}
  \item{AP}{Alkaline Phosphatase of an individual measured in U/L}

}

\author{
Dr. Omar Yaxmehen Belo Chavolla & Dr. Carlos Alberto Fermín Martínez

Based on the work of Morgan Levine et al.

Full papers here: https://www.aging-us.com/article/101414/text; https://journals.plos.org/plosmedicine/article?id=10.1371/journal.pmed.1002718

Levine ME, Lu AT, Quach A, Chen BH, Assimes TL, Bandinelli S, Hou L, Baccarelli AA, Stewart JD, Li Y, Whitsel EA, Wilson JG, Reiner AP, Aviv A, Lohman K, Liu Y, Ferrucci L, Horvath S. An epigenetic biomarker of aging for lifespan and healthspan. Aging (Albany NY). 2018 Apr 18;10(4):573-591. doi: 10.18632/aging.101414. PMID: 29676998; PMCID: PMC5940111.

}
\note{

This version may take longer to estimate PhenoAge for larger datasets.

}

\examples{

## Calculate phenoage in a single individual ##

age1<-phenoage(Age=40, CRP=0.02, Lymph=23.9, Glu=95,
                  Alb=4.4, MCV=93.6, RCDW=12, AP=52,
                  WBC=5.7, Cr=0.7)

age1


}
\keyword{risk}
\keyword{aging}
\keyword{phenoage}
\keyword{mortality}
\concept{biological age}
\concept{biological aging}
