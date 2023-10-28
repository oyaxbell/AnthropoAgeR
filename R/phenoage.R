#' @export phenoage
#' @import flexsurv
#' @import tidyverse
#' @import parallel
#' @import tibble
#' @import tidyr
phenoage<-function(Age, CRP, Lymph, WBC, Glu, RCDW,Alb, Cr, MCV, AP){
  x<-NULL
  Cr<-Cr*88.42
  Glu<-Glu/18
  x<-data.frame(Age, CRP, Lymph, WBC, Glu, RCDW,Alb, Cr, MCV, AP)
  for(i in 1:length(x)){
    PhenoAge <- 141.5 + ((log(-0.00553*log(1-(1-exp((-1.51714*exp(-19.907-
                                                                   0.0336*x$Alb+
                                                                   0.0095*x$Cr+
                                                                   0.1953*x$Glu+
                                                                   0.0954*log(x$CRP)-
                                                                   0.0120*x$Lymph+
                                                                   0.0268*x$MCV+
                                                                   0.3306*x$RCDW+
                                                                   0.00188*x$AP+
                                                                   0.0554*x$WBC+
                                                                   0.0804*x$Age))/(0.0076927)))))))/(0.09165)
    PhenoAge[is.infinite(PhenoAge)]<-NA
    names(PhenoAge) <- NULL
    return(PhenoAge)}}





