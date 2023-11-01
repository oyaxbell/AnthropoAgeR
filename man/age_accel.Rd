\name{age_accel}
\alias{age_accel}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Calculate AnthropoAgeAccel and PhenoAgeAccel to obtain a metric of biological age acceleration
}
\description{
age_accel( ) is used to estimate PhenoAgeAccel and AnthropoAgeAccel, which are the sex-stratified residuals of a linear regression of Age onto AnthropoAge/PhenoAge. This function does not distinguish between PhenoAge, AnthropoAge and S-AnthropoAge and it may be used interchangebly for either metric. Computation is recommended in databases of at least 10 individuals and its performance will be better for larger datasets. The function does not calculate age acceleration for datasets with n<10.

Estimation of AnthropopoAgeAccel uses as inputs chronological age (Age), sex (Sex, codified as "Men" or "Women"), and Phenoage or AnthropoAge (coded as BA). For AnthropoAge either the complete or simplified version may be used.

AnthropoAgeAccel is interpreted as the average deviation of biological from chronological age and is specific for each population. Values >0 indicate accelerated aging rates, whilst values< or =0 indicate non-accelerated aging rates.
}
\usage{
age_accel(Age, BA, Sex)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{Age}{Chronological age of an individual expressed in full years.}
  \item{Sex}{Sex of an individual, it can either take the value "Men" or "Women". The function does not recognize numeric values.}
  \item{BA}{Proxy of biological age, measured in years. This values should be estimated using the anthropoage( ), s_anthropoage( ) or phenoage( ) functions within this package.}

}

\author{
Dr. Omar Yaxmehen Belo Chavolla & Dr. Carlos Alberto Fermín Martínez

Bello-Chavolla Lab, November 2023

Full paper here: https://onlinelibrary.wiley.com/doi/10.1111/acel.13756

Fermín-Martínez CA, Márquez-Salinas A, Guerra EC, Zavala-Romero L, Antonio-Villa NE, Fernández-Chirino L, Sandoval-Colin E, Barquera-Guevara DA, Campos Muñoz A, Vargas-Vázquez A, Paz-Cabrera CD, Ramírez-García D, Gutiérrez-Robledo LM, Bello-Chavolla OY. AnthropoAge, a novel approach to integrate body composition into the estimation of biological age. Aging Cell. 2023 Jan;22(1):e13756. doi: 10.1111/acel.13756. Epub 2022 Dec 22. PMID: 36547004; PMCID: PMC9835580.

}
\note{

For datasets with n<10 a simple substraction of Chronological age minus PhenoAgeAnthropoAge may be used as a proxy of age acceleration. This, however, would not consider deviation from population average rates.

For PhenoAgeAccel, we recommend implementing a sex-stratified estimation similar to AnthropoAge, to reduce sex-based bias in estimation of accelerated aging.

}

\examples{
## Calculate age acceleration in a single individual ##

accel<-age_accel(Age=31, BA=26.2, Sex="Men")

accel

## Calculate age acceleration in a dataset ##

data<-data.frame(Age=c(23,34,45,33,56,76,61,41,32,27),
                 BA=c(25.2,30.6,44.2,33.5,61.2,81.1,57.2,40.7,35.2,26.1),
                 Sex=c("Men", "Women", "Women", "Men", "Women", "Men",
                       "Men", "Men", "Women", "Women"))

data$accel<-age_accel(Age=data$Age, BA=data$BA, Sex=data$Sex)

data$accel

hist(data$accel)


}
\keyword{risk}
\keyword{aging}
\keyword{body composition}
\keyword{mortality}
\concept{biological age}
\concept{biological aging}
