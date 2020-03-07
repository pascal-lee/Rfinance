require(tidyverse)
require(timetk)
require(kableExtra)
require(highcharter)
require(quantmod)
require(PerformanceAnalytics)

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
symbols<-c('SPY','EFA','IJS','EEM','AGG')

prices<-
  getSymbols(symbols,
             src='yahoo',
             from='2013-01-01',
             to ='2020-03-06',
             auto.assign = TRUE,
             warning =FALSE) %>% 
  map(~Ad(get(.))) %>% 
  reduce(merge) %>% 
  `colnames<-`(symbols)

prices_monthly<-
  to.monthly(prices,
             indexAt = 'last',
             OHLC=FALSE)

asset_return_xts<-
  na.omit(Return.calculate(prices_monthly, method='log'))

asset_returns_xts <- 
  na.omit(Return.calculate(prices_monthly, 
                           method = "log"))

asset_returns_xts<-asset_return_xts * 100

asset_returns_long<- 
  prices %>%
  to.monthly(indexAt = "last",
             OHLC=FALSE) %>% 
  tk_tbl(preserve_index = TRUE, 
         rename_index = 'date') %>% 
  gather(asset, returns, -date) %>% 
  group_by(asset) %>% 
  mutate(returns = 
           (log(returns)-log(lag(returns)))*100
            ) %>% 
  na.omit()

highchart(type = 'stock') %>% 
  hc_add_series(asset_return_xts$SPY, type='line')

highchart(type = 'stock') %>% 
  hc_add_series(asset_return_xts$SPY, type='line',
                color = 'green')

highchart(type = 'stock') %>% 
  hc_add_series(asset_return_xts$SPY, type='column')

highchart(type = 'stock') %>% 
  hc_add_series(asset_return_xts$SPY, type='scatter') %>% 
  hc_add_series(asset_return_xts$EEM, type='scatter') 

highchart(type = 'stock') %>% 
  hc_add_series(asset_return_xts$SPY, type='scatter', name='SPY') %>% 
  hc_add_series(asset_return_xts$EFA, type='scatter',name='EFA') %>% 
  hc_tooltip(pointFormat ='{point.x: %Y-%m-%d}
            {point.y:.4f}%'
)


highchart(type = 'stock') %>% 
  hc_add_series(asset_return_xts$SPY, type='scatter', name='SPY') %>% 
  hc_add_series(asset_return_xts$EFA, type='scatter',name='EFA') 



head(asset_return_xts)
head(asset_returns_long)
prices = getSymbols("IBM", from = "2010-01-01", to = "2020-03-06")
R.IBM = Return.calculate(xts(prices), method="discrete")
colnames(R.IBM)="IBM"
chart.CumReturns(R.IBM,legend.loc="topleft", main="Cumulative Daily Returns for IBM")
round(R.IBM,2)