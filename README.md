
<!-- README.md is generated from README.Rmd. Please edit that file -->

# AnthropoAge <img src="inst/figures/AnthropoAge.png" align="right" width="180" height="200"/>

<!-- badges: start -->

[![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/AnthropoAge?color=green)](https://cran.r-project.org/package=AnthropoAge)
[![](http://cranlogs.r-pkg.org/badges/grand-total/AnthropoAge?color=green)](https://cran.r-project.org/package=AnthropoAge)
[![](http://cranlogs.r-pkg.org/badges/AnthropoAge?color=green)](https://cran.r-project.org/package=AnthropoAge)
[![](http://cranlogs.r-pkg.org/badges/last-week/AnthropoAge?color=green)](https://cran.r-project.org/package=AnthropoAge)
<!-- badges: end -->

## Authors

Omar Yaxmehen Bello-Chavolla, Carlos Alberto Fermín-Martínez
<https://bellolab.org>

Instituto Nacional de Geriatría, Mexico City, Mexico

[![](https://img.shields.io/badge/Instagram-E4405F?style=for-the-badge&logo=instagram&logoColor=white)](https://instagram.com/bellochavolla_lab)

[![](https://img.shields.io/badge/GitHub-100000?style=for-the-badge&logo=github&logoColor=white)](https://facebook.com/bellochavollalab)

[![](https://img.shields.io/badge/Facebook-1877F2?style=for-the-badge&logo=facebook&logoColor=white)](https://github.com/oyaxbell)

------------------------------------------------------------------------

The `AnthropoAge` package cfacilitate estimation of second-generation
biological aging measures derived from body-composition measures
(AnthropoAge, S-AnthropoAge) and PhenoAge in R. This package also allows
for estimation of sex-stratified accelerated aging measures
PhenoAgeAccel and AnthropoAgeAccel. These metrics are derived from work
by Fermín-Martínez CA et al (Aging Cell, 2023) and Levine M et al
(Aging, 2018).

AnthropoAge is a second-generation biological aging biomarker developed
to estimate 10-year mortality years expressed as age using
anthropometric measurements. The full version of AnthropoAge uses
chronological age, sex, ethnicity, weight, height, waist circumference,
subscapular and triceps skinfold thickness (for women), and arm and
thigh circunference (for men). The simplified version of AnthropoAge
uses the body-mass index and the waist-to-height ratio. The full version
of AnthropoAge can be calculated using the `anthropoage()` function,
whilst the simplified version can be calculated using the
`s_anthropoage()` function.

PhenoAge is a second-generation aging biomarker developed to estimate
10-year mortality years expressed as age using blood biomarker
measurements. Phenoage uses chronological age, fasting plasma glucose,
serum creatinine, alkaline phosphatase, lymphocyte percentage, red cell
distribution width, mean cell volume, serum albumin, and c-reactive
protein. PhenoAge can be calculated using the `phenoage()` function.

## Installation

You can install the development version of `AnthropoAge` from Github

``` r
# install.package("remotes")   #In case you have not installed it.
remotes::install_github("oyaxbell/anthropoageR")
```

Alternatively, you will soon be able install the released version of
`AnthropoAge` from [CRAN](https://CRAN.R-project.org) with:

``` r
# not approved yet
# install.packages("globorisk")
```

## Example

### AnthropoAge calculation

To calculate AnthropoAge use the `anthropoage()` function. The following
code provides an example for a calculation for males and females using
AnthropoAge. The function can also be used to calculate AnthropoAge in a
large cohort.

``` r
library(AnthropoAge)

## Male
age1<-anthropoage(Age=31, Sex="Men", Weight=75,
              Height=1.73, Ethnicity="Mexican-American",
              Thigh_circumference=49.5, Arm_circumference=27.7,
              Subscapular_skinfold=17, Triceps_skinfold=17.2)

age1

## Female

age2<-anthropoage(Age=24, Sex="Women", Weight=61,
              Height=1.62, Ethnicity="Mexican-American",
              Subscapular_skinfold=17, Triceps_skinfold=17.2,
              Thigh_circumference=49.5, Arm_circumference=27.7)

age2
```

### S- AnthropoAge calculation

To calculate S-AnthropoAge use the `s_anthropoage()`function. The
following code provides an example for a calculation for males and for a
datset using AnthropoAge. The function can also be used to calculate
AnthropoAge in a large cohort; for this latter purpose
the`s_anthropoage_fast()` function is recommended.

``` r
library(AnthropoAge)

## Calculate s_anthropoage in a single individual ##

age1<-s_anthropoage(Age=31, Sex="Men", Weight=75,
              Height=1.73, Ethnicity="Mexican American")

age1

## Calculate  AnthropoAge in a dataset ##

df<-data.frame(Age=c(24, 31, 27), Sex=c("Women", "Men", "Men"),
              Weight=c(61, 73, 68), Height=c(1.61, 1.73, 1.68),
              Waist=c(76, 82, 91), Ethnicity=c("Mexican-American",
              "Mexican-American","Mexican-American"))

df$AnthropoAge<-s_anthropoage_fast(Age=df$Age, Sex=df$Sex, Weight=df$Weight,
              Height=df$Height, Ethnicity=df$Ethnicity)

df$AnthropoAge

```

### PhenoAge calculation

To calculate PhenoAge use the `phenoage()`function. The following code
provides an example for a calculation of PhenoAge in a single
individual.

``` r
library(AnthropoAge)

## Calculate phenoage in a single individual ##

age1<-phenoage(Age=40, CRP=0.02, Lymph=23.9, Glu=95,
                  Alb=4.4, MCV=93.6, RCDW=12, AP=52,
                  WBC=5.7, Cr=0.7)

age1
```

### Age acceleration

To calculate accelerated aging metrics derived from AnthropoAge,
S-AnthropoAge and PhenoAge, the `age_accel()` function must be used.
This provides a sex-based estimate of accelerated aging for all metrics.
AnthropoAgeAccel is interpreted as the average deviation of biological
from chronological age and is specific for each population. Values ≥0
indicate accelerated aging rates, whilst values\<0 indicate
non-accelerated aging rates.

``` r
library(AnthropoAge)

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


```

## References

Levine ME, Lu AT, Quach A, Chen BH, Assimes TL, Bandinelli S, Hou L,
Baccarelli AA, Stewart JD, Li Y, Whitsel EA, Wilson JG, Reiner AP, Aviv
A, Lohman K, Liu Y, Ferrucci L, Horvath S. An epigenetic biomarker of
aging for lifespan and healthspan. Aging (Albany NY). 2018 Apr
18;10(4):573-591. doi: <https://doi.org/10.18632/aging.101414>. PMID:
29676998; PMCID: PMC5940111.

Fermín-Martínez CA, Márquez-Salinas A, Guerra EC, Zavala-Romero L,
Antonio-Villa NE, Fernández-Chirino L, Sandoval-Colin E,
Barquera-Guevara DA, Campos Muñoz A, Vargas-Vázquez A, Paz-Cabrera CD,
Ramírez-García D, Gutiérrez-Robledo LM, Bello-Chavolla OY. AnthropoAge,
a novel approach to integrate body composition into the estimation of
biological age. Aging Cell. 2023 Jan;22(1):e13756. doi:
<https://doi.org/10.1111/acel.13756>. Epub 2022 Dec 22. PMID: 36547004;
PMCID: PMC9835580.
