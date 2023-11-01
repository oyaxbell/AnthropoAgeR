#' @export s_anthropoage
#' @import flexsurv
#' @import tidyverse
#' @import parallel
#' @import tibble
#' @import tidyr

s_anthropoage<-function(Age, Sex, Height, Weight, Waist, Ethnicity){
  # Data frame including Age (years), Sex (coded as "Men" and "Women"), Height (cm), Weight (kg),
  # Waist (cm) and Ethnicity (coded as "White", "Black", "Mexican-American" and "Others")
  BMI<-Weight/(Height^2)
  ICE<-Waist/(Height*100)
  tr_imc <- log(BMI)
  tr_ice <- ICE**(1/3)
  x<-data.frame(Age, Sex, tr_imc, tr_ice, Ethnicity)
  ##Estimate model coefficients based on NHANES models##
  sM1<-1/((exp(coef(gomp1bM1)[1]*120)-1)/((coef(gomp1bM1)[1])))
  b0M1<-coef(gomp1bM1)[2]
  b1M1<-coef(gomp1bM1)[3]
  sW1<-1/((exp(coef(gomp1bF1)[1]*120)-1)/((coef(gomp1bF1)[1])))
  b0W1<-coef(gomp1bF1)[2]
  b1W1<-coef(gomp1bF1)[3]
  ## Loop for S-AnthropoAge estimation ##
  for(i in 1:nrow(x)){
    if(x$Sex[i]=="Women"){
      p1F<-predict(gomp1aF1, newdata = x,type="survival", ci=F, times = c(120))
      pred<-as.numeric(1-p1F$.pred)
      output<-(log(-sW1*log(1-pred))-b0W1)/b1W1}
    else if(x$Sex[i]=="Men") {
      p1M<-predict(gomp1aM1, newdata = x,type="survival", ci=F, times = c(120))
      pred<-as.numeric(1-p1M$.pred)
      output<-(log(-sM1*log(1-pred))-b0M1)/b1M1}
    ##Output
    output[is.infinite(output)]<-NA
    names(output) <- NULL
    return(output)}}
