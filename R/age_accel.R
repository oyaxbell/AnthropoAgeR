#' @export age_accel
#' @import flexsurv
#' @import tidyverse
#' @import parallel
#' @import stats
#' @import tibble
#' @import tidyr
#' @import knitr

age_accel<-function(Age, BA, Sex){
  n<-length(Age)
  if (n<10){return("For optimal calculations please only estimate AntropoAgeAccel for samples greater than or equal to10")}
  else{
    x<-data.frame(Age, BA, Sex)
    for(i in 1:nrow(x)){
      if(x$Sex[i]=="Women"){
        output<-lm(x$BA ~ x$Age, x %>% filter(Sex=="Women")) %>% residuals}
      else if(x$Sex[i]=="Men") {
        output<-lm(x$BA ~ x$Age, x %>% filter(Sex=="Men")) %>% residuals}
  }
    ##Output
    output[is.infinite(output)]<-NA
    names(output) <- NULL
    return(output)}}
