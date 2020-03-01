pkg<-c('magrittr','quantmod','rvest','httr','jsonlite')
new.pkg <-pkg[!pkg %in% installed.packages()[,"Package"]]
if (length(new.pkg)){
  install.packages(new.pkg,dependencies = TRUE)
}
