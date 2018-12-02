library(httr)
library(lubridate)
library(base64enc)

newsAPI <- "apiKey=02f3b9bf72be490ca99636ca0921db7e"
googleCloudAPI <- "AIzaSyAy_zmaU5tKjkq-ApMUY6d7aDSq8FHGA4E"

get_headlines_date_range <- function(source, date1, date2, API_key){
  base <- "https://newsapi.org/v2/everything?"
  sources <- paste("sources=", source, sep="")
  date1 <- paste("from=", ymd(as.character(date1)), sep="")
  date2 <- paste("from=", ymd(as.character(date2)), sep="")
  #API <- newsAPI
  url <- paste(base, sources,"&", date1, "&", date2, "&",API_key, sep="")
  x <- httr::GET(url=url)
  x <- jsonlite::fromJSON(rawToChar(x$content))
  articles <- x$articles
  return(unlist(articles$title))
}

get_headlines_keyword <- function(source, keyword, API_key) {
  base <- "https://newsapi.org/v2/everything?"
  sources <- paste("sources=", source, sep="")
  keyword <- paste("q=", keyword, sep="")
  #API <- newsAPI
  url <- paste(base, sources,"&", keyword, "&", API_key, sep="")
  x <- httr::GET(url=url)
  x <- jsonlite::fromJSON(rawToChar(x$content))
  articles <- x$articles
  return(unlist(articles$title))
}

translate_headlines <- function(headlines, googleCloudAPI){
  API_key <- googleCloudAPI
  source <- "ar"
  target <- "en"
  nh <- length(headlines)
  translated <- rep(NA, nh)
  for (i in 1:nh){
    text <- headlines[i]
    body <- paste("{",
                  "'q':'", text, "',", 
                  "'source':'", source, "',",
                  "'target':'", target, "',",
                  "'format':'text',",  
                  "}", sep="")  
  
  
    base <- "https://translation.googleapis.com/language/translate/v2?key="
    url <- paste(base, API_key, sep="")
  
    x <- httr::POST(url, body = body)
    x <- jsonlite::fromJSON(rawToChar(x$content))
    out <- x$data$translations$translatedText
    translated[i] <- out
  }
  return(translated)
}

text_to_speech <- function(text, googleCloudAPI) {
  
  API_key <- googleCloudAPI
  
  text <- translate_headlines(text,googleCloudAPI)
 
  text <- paste(text, collapse=" ")
  text <- gsub("'", "", text)
  
  input <- paste("'input':{'text':'", text, "'}", sep="")
  voice <- "'voice':{'languageCode':'en-US','name':'en-US-Standard-B','ssmlGender':'MALE'}"
  output <- "'audioConfig':{'audioEncoding':'MP3'}"
  
  s_body <- paste("{", input, ",", voice, ",", output, "}", sep="")
  
  base_url <- "https://texttospeech.googleapis.com/v1/text:synthesize?key="
  url <- paste(base_url, API_key, sep="")
  
  x <- httr::POST(url, body = s_body)
  x <- jsonlite::fromJSON(rawToChar(x$content))
  Sys.setenv(output_string=x$audioContent)
  system("echo $output_string > sound_out.txt")
  browser()
  system("base64 --decode sound_out.txt > sound_out.mp3")
  browser()
  system("afplay sound_out.mp3")
  browser()
  sound_out.mp3 <- base64enc::base64decode(sound_out.txt, sound_out.mp3)
}
