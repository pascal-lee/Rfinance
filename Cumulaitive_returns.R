require(tidyverse)
require(timetk)
require(kableExtra)
require(highcharter)
require(quantmod)
require(PerformanceAnalytics)
require(tidyquant)


pkg<-c('magrittr','quantmod','rvest','httr','jsonlite',
       'readr','readxl','stringr','lubridate','dpyr',
       'tidyr','ggplot2','corrplot','dygraphs',
       'highcharter','plotly','PerformanceAnalytics',
       'nlopter','quadprog','riskPortfolios','cccp',
       'timetk','bromm','stargazer','tidyquant')
new.pkg <-pkg[!pkg %in% installed.packages()[,"Package"]]
if (length(new.pkg)){
  install.packages(new.pkg,dependencies = TRUE)
}

# symbols <- c("XLB", #SPDR Materials sector
#              "XLE", #SPDR Energy sector
#              "XLF", #SPDR Financial sector
#              "XLP", #SPDR Consumer staples sector
#              "XLI", #SPDR Industrial sector
#              "XLU", #SPDR Utilities sector
#              "XLV", #SPDR Healthcare sector
#              "XLK", #SPDR Tech sector
#              "XLY", #SPDR Consumer discretionary sector
#              "RWR", #SPDR Dow Jones REIT ETF
#              "EWJ", #iShares Japan
#              "EWG", #iShares Germany
#              "EWU", #iShares UK
#              "EWC", #iShares Canada
#              "EWY", #iShares South Korea
#              "EWA", #iShares Australia
#              "EWH", #iShares Hong Kong
#              "EWS", #iShares Singapore
#              "IYZ", #iShares U.S. Telecom
#              "EZU", #iShares MSCI EMU ETF
#              "IYR", #iShares U.S. Real Estate
#              "EWT", #iShares Taiwan
#              "EWZ", #iShares Brazil
#              "MCHI",#iShares China,
#              "ERUS",#iShares Russia,
#              "INDA",#iShares India,
#              "EWW", #iShares Maxico
#              "EWP", #iShares MSCI Spain ETF
#              "EWQ", #iShares MSCI France ETF
#              "EZA", #iShares MSCI South Africa ETF
#              "EFA", #iShares EAFE
#              "IGE", #iShares North American Natural Resources
#              "EPP", #iShares Pacific Ex Japan
#              "LQD", #iShares Investment Grade Corporate Bonds
#              "SHY", #iShares 1-3 year TBonds
#              "IEF", #iShares 3-7 year TBonds
#              "TLT" ,#iShares 20+ year Bonds,
#              "SCHP",#US Treasury Inflation-Linked Bond Index
#              'IGSB',#Exposure to short-term U.S. investment grade corporate bonds
#              "LMBS", #generate current income with a secondary objective of capital appreciation
#              "USFR",# the Bloomberg U.S. Treasury Floating Rate Bond Index.
#              "PZA", #The ICE BofAML National Long-Term Core Plus Municipal Securities Index (Index).
#              "SCHG",#The total return of the Dow Jones U.S. Large-Cap Growth Total Stock Market Index. 
#              "IQLT"# Exposure to large- and mid-cap developed international stocks 
# )


symbols <- c("SPY", #SPDR S&P 500
             "EWJ", #iShares Japan
             "EWG", #iShares Germany
             "EWU", #iShares UK
             "EWC", #iShares Canada
             "EWY", #iShares South Korea
             "EWA", #iShares Australia
             "EWH", #iShares Hong Kong
             "EWS",  #iShares Singapore
             "EZU", #iShares MSCI EMU ETF(Eeuro zone)
             "EWT", #iShares Taiwan
             "EWZ", #iShares Brazil
             "MCHI",#iShares China,
             "ERUS",#iShares Russia,
             "INDA",#Shares India,
             "EWW", #Shares Maxico
             "EFA", #SharesiShares EAFE(Europe, Australia, Asia, and the Far East)
             "EWP", #iShares MSCI Spain ETF
             "EWQ", #iShares MSCI France ETF
             "EZA" #iShares MSCI South Africa ETF
)

symbols
# price data
price_data<-tq_get(symbols, from='2020-01-01', to ='2020-08-05',
                   get = 'stock.prices')

# daily returns for our asses
ret_data<-price_data %>% 
  group_by(symbol) %>% 
  tq_transmute(select= adjusted, mutate_fun = periodReturn, period='daily', col_rename = 'return')

#
# creat weigth table
wts<-rep(1,length(symbols))# equal weight
wts_tbl<-tibble(symbol = symbols, wts=wts)
wts_tbl

# joint weights tableand return data
ret_data<-left_join(ret_data, wts_tbl, by='symbol')

# calculate the weight average of our asset returns
ret_data<-ret_data %>% 
  mutate(wt_return=wts*return)

length(symbols)
# return data


