library(httr)

Sys.setlocale("LC_ALL","Chinese")
sessionInfo()

base <- "https://newsapi.org/v2/everything?sources=xinhua-net&apiKey="
api_key <- "5d642184b7ec43dbbf72e8b4dce49304"
url <- paste(base, api_key, sep="")

news <- httr::GET(url=url)
news <- jsonlite::fromJSON(rawToChar(news$content))

title <- news$articles$title
title

install.packages("newsAPI")
library(newsAPI)
