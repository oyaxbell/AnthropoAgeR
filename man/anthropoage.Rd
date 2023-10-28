\name{anthropoage}
\alias{anthropoage}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Calculate the full version of AnthropoAge
}
\description{
anthropoage() is used to estimate the simplified version of AnthropoAge, using as inputs chronological age (Age), sex (Sex, codified as "Men" or "Women"), height in meters (Height), weight in kilograms (Weight), waist cicumference in centimeters (Waist), subscapular and tricipital skinfold in milimeter (Subscapular_skinfold and Triceps_skinfold), arm circunference (Arm_circumference), thigh circumference (Thigh_circumference) and Ethnicity.

AnthropoAge is interpreted as the estimated 10-year risk of all cause mortality based on body composition and is a proxy of biological age.
}
\usage{
anthropoage(Age, Sex, Ethnicity, Height, Weight, Waist,
            Subscapular_skinfold, Triceps_skinfold,
            Thigh_circumference, Arm_circumference)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{Age}{Chronological age of an individual expressed in full years.}
  \item{Sex}{Sex of an individual, it can either take the value "Men" or "Women". The function does not recognize numeric values.}
  \item{Weight}{Weight of an individual measured in kilograms.}
  \item{Height}{Height of an individual measured in meters. Do not use height in centimeters.}
  \item{Waist}{Waist circumference of an individual measured in centimeres.}
  \item{Subscapular_skinfold}{Measurement of subscapular skinfold in an individual in milimeters.}
  \item{Triceps_skinfold}{Measurement of tricipital skinfold in an individual in milimeters.}
  \item{Arm_circumference}{Measurement of arm cricumference in an individual in centimeters.}
  \item{Thigh_circumference}{Measurement of thigh cricumference in an individual in centimeters.}
  \item{Ethnicity}{Ethnicity of an individual based on NHANES codification, it can either take the following values: "White", "Black", "Mexican-American" or "Other"}

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
Dr. Omar Yaxmehen Belo Chavolla & Dr. Carlos Alberto Fermín Martínez

Bello-Chavolla Lab, November 2023

Full paper here: https://onlinelibrary.wiley.com/doi/10.1111/acel.13756

Fermín-Martínez CA, Márquez-Salinas A, Guerra EC, Zavala-Romero L, Antonio-Villa NE, Fernández-Chirino L, Sandoval-Colin E, Barquera-Guevara DA, Campos Muñoz A, Vargas-Vázquez A, Paz-Cabrera CD, Ramírez-García D, Gutiérrez-Robledo LM, Bello-Chavolla OY. AnthropoAge, a novel approach to integrate body composition into the estimation of biological age. Aging Cell. 2023 Jan;22(1):e13756. doi: 10.1111/acel.13756. Epub 2022 Dec 22. PMID: 36547004; PMCID: PMC9835580.
}
\note{

This version may take longer to estimate AnthropoAge for larger datasets. For computationally intensive calculations, consider using anthropoage_fast()

}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
%% ~~objects to See Also as \code{\link{help}}, ~~~
}
\examples{
## Calculate anthropoage in a single individual ##

## Male
age1<-anthropoage(Age=31, Sex="Men", Weight=75,Waist=81,
              Height=1.73, Ethnicity="Mexican-American",
              Thigh_circumference=49.5, Arm_circumference=27.7,
              Subscapular_skinfold=17, Triceps_skinfold=17.2)

age1

## Female

age2<-anthropoage(Age=24, Sex="Women", Weight=61,Waist=75,
              Height=1.62, Ethnicity="Mexican-American",
              Subscapular_skinfold=17, Triceps_skinfold=17.2,
              Thigh_circumference=49.5, Arm_circumference=27.7)

age2


}
\keyword{risk}
\keyword{aging}
\keyword{body composition}
\keyword{mortality}
\concept{biological age}
\concept{biological aging}
