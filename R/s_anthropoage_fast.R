#' @export s_anthropoage_fast
#' @import flexsurv
#' @import tidyverse
#' @import parallel
#' @import tibble
#' @import tidyr

s_anthropoage_fast<-function(Age, Sex, Height, Weight, Waist, Ethnicity){
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
  ## Loop for parallel S-AnthropoAge estimation ##
  cl <- makeCluster(detectCores()); registerDoParallel(cl); chunk_size <- 1000
  it <- iter(seq(1, nrow(x), by = chunk_size), chunksize = chunk_size)
  for(i in 1:nrow(x)){
    if(x$Sex[i]=="Women"){
      predict_chunk <- function(idx) {chunk <- x[idx:min(idx + chunk_size - 1, nrow(x)), ]
      predict(gomp1aF1, newdata = chunk, type = "survival", ci = FALSE, times = c(120))}
      p1F<-foreach(idx = (it[["state"]][["obj"]]), .combine = rbind) %dopar% {predict_chunk(idx)}
      pred<-as.numeric(1-p1F$.pred_survival)
      output<-(log(-sW1*log(1-pred))-b0W1)/b1W1}
    else if(x$Sex[i]=="Men") {
      predict_chunk <- function(idx) {chunk <- x[idx:min(idx + chunk_size - 1, nrow(x)), ]
      predict(gomp1aM1, newdata = chunk, type = "survival", ci = FALSE, times = c(120))}
      p1M<-foreach(idx = (it[["state"]][["obj"]]), .combine = rbind) %dopar% {predict_chunk(idx)}
      pred<-as.numeric(1-p1M$.pred_survival)
      output<-(log(-sM1*log(1-pred))-b0M1)/b1M1}
    stopCluster(cl)
    ##Output
    output[is.infinite(output)]<-NA
    names(output) <- NULL
    return(output)}}
