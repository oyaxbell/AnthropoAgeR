\name{s_anthropoage}
\alias{s_anthropoage}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Calculate the simplified version of AnthropoAge
}
\description{
s_anthropoage() is used to estimate the simplified version of AnthropoAge, using as inputs chronological age (Age), sex (Sex, codified as "Men" or "Women"), height in meters (Height), weight in kilograms (Weight), waist cicumference in centimeters (Waist) and Ethnicity.

S-AnthropoAge is interpreted as the estimated 10-year risk of all cause mortality based on body composition and is a proxy of biological age.
}
\usage{
s_anthropoage(Age, Sex, Height, Weight, Waist, Ethnicity)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{Age}{Chronological age of an individual expressed in full years.}
  \item{Sex}{Sex of an individual, it can either take the value "Men" or "Women". The function does not recognize numeric values.}
  \item{Weight}{Weight of an individual measured in kilograms.}
  \item{Height}{Height of an individual measured in meters. Do not use height in centimeters.}
  \item{Waist}{Waist circumference of an individual measured in centimeres.}
  \item{Ethnicity}{Ethnicity of an individual based on NHANES codification, it can either take the following values: "White", "Black", "Mexican-American" or "Others"}

}

\author{
Dr. Omar Yaxmehen Belo Chavolla & Dr. Carlos Alberto Fermín Martínez

Bello-Chavolla Lab, November 2023

Full paper here: https://onlinelibrary.wiley.com/doi/10.1111/acel.13756

Fermín-Martínez CA, Márquez-Salinas A, Guerra EC, Zavala-Romero L, Antonio-Villa NE, Fernández-Chirino L, Sandoval-Colin E, Barquera-Guevara DA, Campos Muñoz A, Vargas-Vázquez A, Paz-Cabrera CD, Ramírez-García D, Gutiérrez-Robledo LM, Bello-Chavolla OY. AnthropoAge, a novel approach to integrate body composition into the estimation of biological age. Aging Cell. 2023 Jan;22(1):e13756. doi: 10.1111/acel.13756. Epub 2022 Dec 22. PMID: 36547004; PMCID: PMC9835580.
}
\note{

This version may take longer to estimate AnthropoAge for larger datasets. For computationally intensive calculations, consider using s_anthropoage_fast()

}

\examples{
## Calculate s_anthropoage in a single individual ##

age1<-s_anthropoage(Age=31, Sex="Men", Weight=75,Waist=81,
              Height=1.73, Ethnicity="Mexican-American")

age1

## Calculate  AnthropoAge in a dataset ##

df<-data.frame(Age=c(24, 31, 27), Sex=c("Women", "Men", "Men"),
              Weight=c(61, 73, 68), Height=c(1.61, 1.73, 1.68),
              Waist=c(76, 82, 91), Ethnicity=c("Mexican-American",
              "Mexican-American","Mexican-American"))

df$AnthropoAge<-s_anthropoage(Age=df$Age, Sex=df$Sex, Weight=df$Weight,
              Height=df$Height, Ethnicity=df$Ethnicity, Waist=df$Waist)

df$AnthropoAge



}
\keyword{risk}
\keyword{aging}
\keyword{body composition}
\keyword{mortality}
\concept{biological age}
\concept{biological aging}
