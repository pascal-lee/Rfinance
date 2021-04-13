pkg<-c('magrittr','quantmod','rvest','httr','jsonlite',
       'readr','readxl','stringr','lubridate','dpyr',
       'tidyvese','ggplot2','corrplot','dygraphs',
       'highcharter','plotly','PerformanceAnalytics',
       'nlopter','quadprog','riskPortfolios','cccp',
       'timetk','bromm','stargazer','tidyquant','uandl', 'xts')
new.pkg <-pkg[!pkg %in% installed.packages()[,"Package"]]
require(tidyquant)
require(tidyverse)
if (length(new.pkg)){
  install.packages(new.pkg,dependencies = TRUE)
}
symbols <- c("XLB", #SPDR Materials sector
             "XLE", #SPDR Energy sector
             "XLF", #SPDR Financial sector
             "XLP", #SPDR Consumer staples sector
             "XLI", #SPDR Industrial sector
             "XLU", #SPDR Utilities sector
             "XLV", #SPDR Healthcare sector
             "XLK", #SPDR Tech sector
             "XLY", #SPDR Consumer discretionary sector
             "RWR", #SPDR Dow Jones REIT ETF
             "EWJ", #iShares Japan
             "EWG", #iShares Germany
             "EWU", #iShares UK
             "EWC", #iShares Canada
             "EWY", #iShares South Korea
             "EWA", #iShares Australia
             "EWH", #iShares Hong Kong
             "EWS", #iShares Singapore
             "IYZ", #iShares U.S. Telecom
             "EZU", #iShares MSCI EMU ETF
             "IYR", #iShares U.S. Real Estate
             "EWT", #iShares Taiwan
             "EWZ", #iShares Brazil
             "EFA", #iShares EAFE
             "IGE", #iShares North American Natural Resources
             "EPP", #iShares Pacific Ex Japan
             "LQD", #iShares Investment Grade Corporate Bonds
             "SHY", #iShares 1-3 year TBonds
             "IEF", #iShares 3-7 year TBonds
             "TLT" ,#iShares 20+ year Bonds,
             'TIPS'
)

symbols<-c('SPY','EFA','IJS','EEM','AGG','005930.KS')

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
  hc_add_series(asset_return_xts$SPY, type='column',name='SPY') %>% 
  hc_add_series(asset_return_xts$EEM, type='column',name='EEM') %>%
  hc_add_series(asset_return_xts$`005930.KS`, type='column',name='SS') %>% 
  hc_tooltip(pointFormat ='{point.x: %Y-%m-%d}
            {point.y:.4f}%'
             )

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
  hc_add_series(asset_return_xts$EFA, type='scatter',name='EFA') %>% 
  hc_add_series(asset_return_xts$`005930.KS`, type='scatter',name='005930.KS') %>% 
  hc_tooltip(pointFormat ='{point.x: %Y-%m-%d}
            {point.y:.4f}%'
  )

highchart(type = 'stock') %>% 
  hc_add_series(asset_return_xts$SPY, type='scatter', name='SPY') %>% 
  hc_add_series(asset_return_xts$EFA, type='scatter',name='EFA') 



head(asset_return_xts)
head(asset_returns_long)
prices_IBM = getSymbols("IBM", from = "2010-01-01", to = "2020-03-06")
R.IBM = Return.calculate(xts(prices_IBM), method="discrete")
colnames(R.IBM)="IBM"
chart.CumReturns(R.IBM,legend.loc="topleft", main="Cumulative Daily Returns for IBM")
round(R.IBM,2)