library(httr, quietly = T)
setwd("C:/Users/Jaquelin Martinez/Desktop/MATH 110/hw 12/Martinez")

#I made both newspaper api key and google api key global objects
globo_api_key <- "82928f3a320a4614b4e9bef5ba051b69"
google_api_key <- "AIzaSyA6BWicoLRoK3doX7oyNzs5YMEzxg8Q47A"

#this function helps you construct a url for your newspaper
search_newspaper_url <- function(globo_key, word) {
  base <- "https://newsapi.org/v2/everything?q="
  query <- word
  sort <- "&sortBy=relevancy"
  mid_base<- "&sources=globo&apiKey="
  key <- globo_key
  url <- paste(base,query,sort,mid_base,key, sep="")
  return(url)
}


url <-  search_newspaper_url(globo_api_key, "Bolsonaro")



#this function helps you access the newspaper using the url function
#I did this here, so I would only have to insert my url in the following functions
access_newspaper <- function (url) {
  
  x <- httr::GET(url=url)
  x <- jsonlite::fromJSON(rawToChar(x$content))
  return(x)
}



#this function will help you translate text of the ith title in the results
translate_text <- function(url, google_api, i) {
  newspaper <- access_newspaper(url)
  
  text <- unlist(newspaper$articles$title)
  text <- text[i]
  source <- "pt"
  target <- "en"
  
  body <- paste("{",
                "'q':'", text, "',", 
                "'source':'", source, "',",
                "'target':'", target, "',",
                "'format':'text',",  
                "}", sep="")
  
  base <- "https://translation.googleapis.com/language/translate/v2?key="
  url <- paste(base, google_api, sep="")
  x <- httr::POST(url, body = body)
  x <- jsonlite::fromJSON(rawToChar(x$content))
  out <- x$data$translations$translatedText

  return(out)
}

#this function will help you turn your translated text into speech
text_to_speech <- function(url, google_api, i) {
  text <- translate_text(url, google_api, i)
  
  input <- paste("'input':{'text':'", text, "'}", sep="")
  voice <- "'voice':{'languageCode':'en-AU','name':'en-AU-Standard-A','ssmlGender':'FEMALE'}"
  output <- "'audioConfig':{'audioEncoding':'MP3'}"

  s_body <- paste("{", input, ",", voice, ",", output, "}", sep="")
  
  base_url <- "https://texttospeech.googleapis.com/v1/text:synthesize?key="
  url <- paste(base_url, google_api, sep="")
  
  x <- httr::POST(url, body = s_body)
  x <- jsonlite::fromJSON(rawToChar(x$content))
  
  Sys.setenv(output_string=x$audioContent)
  audio <- x$audioContent

  con <- file("sound.txt", "w")
  writeLines(audio, con = con)
  close(con)

  shell("certutil -decode sound.txt sound.mp3")
  shell("start sound.mp3")
 
}

