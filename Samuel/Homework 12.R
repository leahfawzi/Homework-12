#News API - NewsAPI.org- filtering for XinHua 
library(httr)
library(dplyr)
library(lubridate)
library(base64)

#Example of URL "https://newsapi.org/v2/everything?q=bitcoin&apiKey=8665b12062004f058c454ea7c4b2bd9a"
#make an object for API Key


samAPIkey <- "8665b12062004f058c454ea7c4b2bd9a"


#Function for returning artlices in a given span of time
getHeadlines_TimeSpan <- function(date1,date2, APIkey){
  base <- "https://newsapi.org/v2/everything?"
  sources <- "xinhua-net"
  url1 <- paste(base,"sources=",sources,"&","from=",date1,"&","to=",date2,"&sortBy=popularity&","apiKey=",
                APIkey, sep = "")

  x <- httr::GET(url=url1)
  x <- jsonlite::fromJSON(rawToChar(x$content))
  return(x$articles$title)
}


#Function that queries based on a keyword
getHeadlines_keyword <- function(keyword, APIkey){
  base <- "https://newsapi.org/v2/everything?"
  sources <- "xinhua-net"
  url1 <- paste(base,"sources=",sources,"&","q=",keyword,"&sortBy=popularity&","apiKey=",
                APIkey, sep = "")
  x <- httr::GET(url=url1)
  x <- jsonlite::fromJSON(rawToChar(x$content))
  return(x$articles$title)
}

#Function that queries based on a keyword and time span:
getHeadlinesTime_keyword <- function(keyword,date1,date2,APIkey){
  base <- "https://newsapi.org/v2/everything?"
  sources <- "xinhua-net"
  url1 <- paste(base,"sources=",sources,"&","q=",keyword,"&","from=",date1,"&","to=",date2,"&sortBy=popularity&","apiKey=",
                APIkey, sep = "")
  x <- httr::GET(url=url1)
  x <- jsonlite::fromJSON(rawToChar(x$content))
  return(x$articles$title)
}



#Function that translates and retruns a data.frame 

googleAPI_key <- "AIzaSyCOrcUDCTzVLfCgTekyFYhT_S4hJthGyak"

headline_translator <- function(headlines,gAPI_key){
  nh <- length(headlines)
  en_trans <- rep(NA,nh)
  for (i in 1:nh){
    ch <- headlines[i]
    source <- "zh"
    target <- "en"
    body <- paste("{",
                  "'q':'", ch, "',",
                  "'source':'", source, "',",
                  "'target':'", target, "',",
                  "'format':'text'",  
                  "}", sep="")
    
    base <- "https://translation.googleapis.com/language/translate/v2?key="
    url <- paste(base, gAPI_key, sep="")
    
    x <- httr::POST(url, body = body)
    x <- jsonlite::fromJSON(rawToChar(x$content))
    en_trans[i] <- x$data$translations$translatedText
    
  }
  
  return(data.frame(Original = headlines, Translation = en_trans))
}

#text to speech- english

text_to_speech  <-function(text, gAPIkey){

  text  <-paste(text,collapse="  ")
  text  <-gsub("'","",  text)
  
  input  <-paste("'input':{'text':'",  text,"'}",sep="")
  voice  <-"'voice':{'languageCode':'en-GB','name':'en-GB-Standard-C','ssmlGender':'FEMALE'}"
  output  <-"'audioConfig':{'audioEncoding':'MP3'}"
  
  s_body  <-paste("{",  input,",",  voice,",",  output,"}",sep="")
  base_url <- "https://texttospeech.googleapis.com/v1/text:synthesize?key="
  base_url  <-url  <-paste(base_url,gAPIkey,sep="")
  
  x  <-httr::POST(url,body  =s_body)
  x  <-jsonlite::fromJSON(rawToChar(x$content))
  browser()
  Sys.setenv(output_string=x$audioContent)
  system("echo $output_string > sound_out.txt")
  system("base64 --decode sound_out.txt > sound_out.mp3")
  system("afplay sound_out.mp3")
}

