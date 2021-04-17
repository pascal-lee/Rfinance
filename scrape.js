# Javascript for creating a new file, scrape.js
writeLines("var url = NULL;
           var page = new WebPage();
           var fs = require('fs');
           page.open(url, function (status) {
           just_wait();
           });
           function just_wait() {
           setTimeout(function() {
           fs.write('1.html', page.content, 'w');
           phantom.exit();
           }, 2500);
           }
           ",
           con = "scrape.js")

# Function for scraping from a URL
js_scrape <- function(url,
                      js_path = "scrape.js",
                      phantompath = "/usr/local/Cellar/phantomjs/2.1.1/bin/phantomjs"){

  # Replace url in scrape.js
  lines <- readLines(js_path)
  lines[1] <- paste0("var url ='", url ,"';")
  writeLines(lines, js_path)

  # Run from command line
  command <- paste(phantompath, js_path, sep = " ")
  system(command)

}

# Scrape it
js_scrape(url = "https://investor.vanguard.com/etf/list#/etf/asset-class/month-end-returns")
