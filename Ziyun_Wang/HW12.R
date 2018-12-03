# By: Ziyun Wang
#### MATH110 HW 12 ####
library(httr)

# get_headlines #
get_headlines <- function(word_given){
  base <- "https://newsapi.org/v2/everything?sources=le-monde&apiKey="
  ZiyunApiKey <- "88f66b32d51a44bd88e3d6e8f21d1751"
  url1 <- paste(base, ZiyunApiKey, sep="")
  
  x <- httr::GET(url=url1)
  x <- jsonlite::fromJSON(rawToChar(x$content))
  
  titles <- x$articles$title
  nhits <- titles[grep(word_given, titles)]
  return(nhits)
}


# translate_headlines #
#Function that translates

translate_headlines <- function(nhits){
  GoogleAPI_key <- "AIzaSyDnv3wqborQ62nUDZr9tJb8Thc5i9znxOk"
  text <- nhits
  source <- "fr"
  target <- "en"
  
  body <- paste("{",
                "'q':'", text, "',", 
                "'source':'", source, "',",
                "'target':'", target, "',",
                "'format':'text',",  
                "}", sep="")
  
  base <- "https://translation.googleapis.com/language/translate/v2?key="
  url <- paste(base, GoogleAPI_key, sep="")
  
  x <- httr::POST(url, body = body)
  x <- jsonlite::fromJSON(rawToChar(x$content))
  out <- x$data$translations$translatedText
  return(out)
}

# text to speech - english #

text_to_speech <- function(out){
  GoogleAPI_key <- "AIzaSyDnv3wqborQ62nUDZr9tJb8Thc5i9znxOk"
  text <- paste(out, collapse=" ")
  text <- gsub("'", "", text)
  
  input <- paste("'input':{'text':'", text, "'}", sep="")
  voice <- "'voice':{'languageCode':'en-GB','name':'en-GB-Standard-C','ssmlGender':'FEMALE'}"
  output <- "'audioConfig':{'audioEncoding':'MP3'}"
  
  s_body <- paste("{", input, ",", voice, ",", output, "}", sep="")
  
  base_url <- "https://texttospeech.googleapis.com/v1/text:synthesize?key="
  url <- paste(base_url, GoogleAPI_key, sep="")
  
  x <- httr::POST(url, body = s_body)
  x <- jsonlite::fromJSON(rawToChar(x$content))
  Sys.setenv(output_string=x$audioContent)
  system("echo $output_string > LeMonde_out.txt")
  
  system("base64 --decode LeMonde_out.txt > LeMonde_out.mp3")
  system("afplay LeMonde_out.mp3")
  
}


# Example #
GoogleAPI_key <- "AIzaSyCOrcUDCTzVLfCgTekyFYhT_S4hJthGyak"
nhits <- get_headlines("découverte")
out <- translate_headlines(nhits)
text_to_speech(out)

nhits
out




