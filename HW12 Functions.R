#Function to return a base url with the domain and search word
get_base <- function(api, keyword){
  base <- "https://newsapi.org/v2/everything?"
  domain <- "domains=elmundo.es"
  query <- paste("q=", keyword, sep="")
  
  url <- paste(base, domain, sep = "")
  url <- paste(url, query, sep="&")
  url <- paste(url, api, sep="&apiKey=")
  url <- paste(url, "100", sep="&pageSize=")
  
  return(url)
}

#Function for the articles for a search keyword given an api
get_article_keyword <- function(api, keyword){
  url <- get_base(api, keyword)
  
  df <- httr::GET(url=url)
  df <- jsonlite::fromJSON(rawToChar(df$content))
  articles <- df$articles
  
  articles <- articles$content
  
  return(articles)
}

#Function to get the content of all articles with the given keyword published on the given date
get_word_dates <- function(api, keyword, date){
  url <- get_base(api, keyword)
  url <- paste(url, date, sep="&from=")
  url <- paste(url, date, sep="&to=")
  
  df <- httr::GET(url=url)
  df <- jsonlite::fromJSON(rawToChar(df$content))
  
  articles <- df$articles
  articles <- articles$content
  return(articles)
}

#Function for the mumber of articles written on a given topic 
get_narticles <- function(api, keyword){
  url <- get_base(api, keyword)
  
  df <- httr::GET(url=url)
  df <- jsonlite::fromJSON(rawToChar(df$content))
  
  nresults <- df$totalResults
  return(nresults)
}

#Function to return all articles written on a given day 
get_articles_dates <- function(api, date){
  base <- "https://newsapi.org/v2/everything?"
  domain <- "domains=elmundo.es"
  
  url <- paste(base, domain, sep = "")
  url <- paste(url, date, sep="&from=")
  url <- paste(url, date, sep="&to=")
  url <- paste(url, api, sep="&apiKey=")
  url <- paste(url, "100", sep="&pageSize=")
  
  df <- httr::GET(url=url)
  df <- jsonlite::fromJSON(rawToChar(df$content))
  
  articles <- df$articles
  articles <- articles$content
  return(articles)
}

#Function for the headlines for a given keyword
get_headline_keyword <- function(api, keyword){
  url <- get_base(api, keyword)
  
  df <- httr::GET(url=url)
  df <- jsonlite::fromJSON(rawToChar(df$content))
  articles <- df$articles
  
  articles <- articles$title
  
  return(articles)
}

#Function for the headlines on a given date
get_headlines_dates <- function(api, date){
  base <- "https://newsapi.org/v2/everything?"
  domain <- "domains=elmundo.es"
  
  url <- paste(base, domain, sep = "")
  url <- paste(url, date, sep="&from=")
  url <- paste(url, date, sep="&to=")
  url <- paste(url, api, sep="&apiKey=")
  url <- paste(url, "100", sep="&pageSize=")
  
  df <- httr::GET(url=url)
  df <- jsonlite::fromJSON(rawToChar(df$content))
  
  articles <- df$articles
  articles <- articles$title
  return(articles)
}