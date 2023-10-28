#' @export anthropoage
#' @import flexsurv
#' @import tidyverse
#' @import parallel
#' @import tibble
#' @import tidyr
anthropoage<-function(Age, Sex, Ethnicity,Height, Weight, Waist, Subscapular_skinfold,
                      Triceps_skinfold,Thigh_circumference,
                      Arm_circumference){
  if(missing(Subscapular_skinfold)) {
    Subscapular_skinfold<-1
  } else {
    Subscapular_skinfold<-Subscapular_skinfold
  }
  if(missing(Triceps_skinfold)) {
    Triceps_skinfold<-1
  } else {
    Triceps_skinfold<-Triceps_skinfold
  }
  if(missing(Thigh_circumference)) {
    Thigh_circumference<-1
  } else {
    Thigh_circumference<-Thigh_circumference
  }
  if(missing(Arm_circumference)) {
    Arm_circumference<-1
  } else {
    Arm_circumference<-Arm_circumference
  }
  BMI<-Weight/(Height^2)
  ICE<-Waist/(Height*100)
  tr_weight<-log(Weight)
  tr_imc<-log(BMI)
  tr_ice<-ICE**(1/3)
  tr_height<-(Height)**(1/3)
  tr_subs<-(Subscapular_skinfold)**(1/3)
  tr_tric<-(Triceps_skinfold)**(1/3)
  tr_thigh<-log(Thigh_circumference)
  tr_armc<-sqrt(Arm_circumference)
  x<-data.frame(Age, Sex, Ethnicity,tr_imc, tr_ice, tr_weight, tr_subs, tr_tric,
                tr_height, tr_armc, tr_thigh)
  ##Estimate model coefficients based on NHANES models##
  sM<-1/((exp(coef(gomp1bM)[1]*120)-1)/((coef(gomp1bM)[1])))
  b0M<-coef(gomp1bM)[2]
  b1M<-coef(gomp1bM)[3]
  sW<-1/((exp(coef(gomp1bF)[1]*120)-1)/((coef(gomp1bF)[1])))
  b0W<-coef(gomp1bF)[2]
  b1W<-coef(gomp1bF)[3]
  ## Loop for AnthropoAge estimation ##
  for(i in 1:nrow(x)){
    if(x$Sex[i]=="Women"){
      p1F<-predict(gomp1aF, newdata =x,type="survival", ci=F, times = c(120))
      pred<-as.numeric(1-p1F$.pred)
      output<-(log(-sW*log(1-pred))-b0W)/b1W}
    else if (x$Sex[i]=="Men") {
      p1M<-predict(gomp1aM, newdata =x,type="survival", ci=F, times = c(120))
      pred<-as.numeric(1-p1M$.pred)
      output<-(log(-sM*log(1-pred))-b0M)/b1M}
    ##Output
    names(output) <- NULL
    output[is.infinite(output)]<-NA
    return(output)}}

