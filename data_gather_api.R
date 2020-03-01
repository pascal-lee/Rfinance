pkg<-c('magrittr','quantmod','rvest','httr','jsonlite',
       'readr','readxl','stringr','lubridate','dpyr',
       'tidyr','ggplot2','corrplot','dygraphs',
       'highcharter','plotly','PerformanceAnalytics',
       'nlopter','quadprog','riskPortfolios','cccp',
       'timetk','bromm','stargazer')
new.pkg <-pkg[!pkg %in% installed.packages()[,"Package"]]
if (length(new.pkg)){
  install.packages(new.pkg,dependencies = TRUE)
}

require(quantmod)
getSymbols('AAPL')
head(AAPL)                                                                            
chart_Series(Ad(AAPL))

data <-getSymbols('AAPL', from ='2000-01-01', to = '2018-12-31', auto.assign = FALSE)
head(data)
