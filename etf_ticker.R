require(tidyverse)
require(tidyquant)
require(rvest)
require(httr)
require(jsonlite)
require(xml2)
require(RCurl)
# define url
url<-'https://finance.naver.com/sise/etf.nhn'
url<-'https://finance.naver.com/sise/sise_deposit.nhn'
url<-'https://finance.naver.com/sise/sise_market_sum.nhn?sosok=0&page=1'
url<-"https://finance.naver.com/api/sise/etfItemList.nhn"

Sys.setlocale("LC_ALL","en_US.UTF-8")
etf_raw<- fromJSON(getURL(url, encoding = "en_US.UTF-8"))
lapply(etf_raw,head)
Sys.setlocale("LC_ALL")


etf_df<-data.frame(ticker=etf_raw$result$etfItemList$itemcode, etf_name=etf_raw$result$etfItemList$itemname)
head(etf_df,n=10)
f
#i<-0dfdf
#url<-paste0('https://finance.naver.com/sise/''sise_market_sum.nhn?sosok=',i,'&page=1')
# connect web site(naver)
down_table<-GET(url)

#extract table data

etf_ticker<-read_html(url,encoding = 'EUC-KR') %>%
  html_node(.,'tobdy')#%>%
  html_nodes(.,'td')
  html_text()
  html_table()
  html_nodes(.,'td') #%>% 
  html_nodes(.,'a') %>% 
  html_attr(.,'href')
  html_table(fill = TRUE)
  html_nodes(.,'.pgPR') #%>% 
  html_nodes(.,'a') %>% 
  html_attr(.,'href')

  etf_ticker
  html_nodes(xpath = '//*[@id="etfItemTable"]/tr[3]/td[1]/a') #%>% 
html_table()
head(etf_ticker, n=10)
etf_ticker[[2]]
down_table

url<-'https://www.baseball-reference.com/leagues/MLB/2019.shtml'   
web_baseball_ref<-read_html(url) %>% 
  html_nodes(xpath = '//*[@id="teams_standard_batting"]') %>% 
  html_table() %>% 
  .[[1]] %>% 
  filter(Tm != '', Tm !='Tm', Tm != 'LgAvg')

web_baseball_ref
