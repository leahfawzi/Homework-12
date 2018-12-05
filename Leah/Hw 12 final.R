library(httr)

#find titles for 6 recent articles for a specific topic

get_articles <- function(topic, api_key){
  base <- "https://newsapi.org/v2/everything?sources=cnn-es"
  
  base2 <- "q="
  end_base <- "apiKey="
  
  url <- paste(base, "&", base2,topic, "&",end_base,api_key, sep="")
  
  x <- httr::GET(url=url)
  x <- jsonlite::fromJSON(rawToChar(x$content))
  titles <- x$articles$title[1:5]
  return(titles)
}

#find titles for headlines from certain time period
get_headlines <- function(api_key){
  base <- "https://newsapi.org/v2/top-headlines?sources=cnn-es"
  end_base <- "apiKey="
  
  url <- paste(base, "&",end_base, api_key, sep="")
  x <- httr::GET(url=url)
  x <- jsonlite::fromJSON(rawToChar(x$content))
  titles <- x$articles$title
  return(titles)
}

#inputs
#source <- "es"
#target <- "en"
#google_api_key <- "AIzaSyB-iMKY9sQ2gTPvrD0btoD7U2rZBwr3fas"
#text <- get_articles("terrorismo","4cc76b2120ca48169b5b0466236a98c3")

#function to translate any text
translate_text <- function(google_api_key, source, target, text){
  body <- paste("{",
                "'q':'", text, "',", 
                "'source':'", source, "',",
                "'target':'", target, "',",
                "'format':'text',",  
                "}", sep="")
  
  base <- "https://translation.googleapis.com/language/translate/v2?key="
  url <- paste(base, google_api_key, sep="")
  out <- rep(NA, length(body))
  for(i in 1:length(body)){
    y <- httr::POST(url, body = body[i])
    y <- jsonlite::fromJSON(rawToChar(y$content))
    out[i]<- y$data$translations$translatedText
  }
  return(out)
}

#function to turn text to speech

text_to_speech <- function(text, google_api_key){
text2 <- paste(text, collapse=" ")

input <- paste("'input':{'text':'", text2, "'}", sep="")
voice <- "'voice':{'languageCode':'en-US','name':'en-US-Standard-C','ssmlGender':'FEMALE'}"
output <- "'audioConfig':{'audioEncoding':'MP3'}"

s_body <- paste("{", input, ",", voice, ",", output, "}", sep="")

base_url <- "https://texttospeech.googleapis.com/v1/text:synthesize?key="
url <- paste(base_url, google_api_key, sep="")
x <- httr::POST(url, body = s_body)
x <- jsonlite::fromJSON(rawToChar(x$content))

Sys.setenv(output_string=x$audioContent)
system("echo $output_string > sound_out.txt")

system("base64 --decode sound_out.txt > sound_out.mp3")
system("afplay sound_out.mp3")
}