get_translated <- function(text, api){

source <- "es"
target <- "en"
news <- text

body <- paste("{",
              "'q':'", news, "',", 
              "'source':'", source, "',",
              "'target':'", target, "',",
              "'format':'text',",  
              "}", sep="")

base <- "https://translation.googleapis.com/language/translate/v2?key="
url <- paste(base, api, sep="")

x <- httr::POST(url, body = body)
x <- jsonlite::fromJSON(rawToChar(x$content))

out <- x$data$translations$translatedText

return(out)
}

get_spoken <- function(text, api){
  text <- paste(text, collapse=" ")
  
  input <- paste("'input':{'text':'", text, "'}", sep="")
  voice <- "'voice':{'languageCode':'nl-NL','name':'nl-NL-Standard-A','ssmlGender':'FEMALE'}"
  output <- "'audioConfig':{'audioEncoding':'MP3'}"
  
  s_body <- paste("{", input, ",", voice, ",", output, "}", sep="")
  
  base_url <- "https://texttospeech.googleapis.com/v1/text:synthesize?key="
  url <- paste(base_url, api, sep="")
  
  x <- httr::POST(url, body = s_body)
  x <- jsonlite::fromJSON(rawToChar(x$content))
  x <- x$audioContent
  
  shell("del translated.txt")
  con <- file("translated.txt", "w")
  writeLines(x, con=con)
  close(con)
  
  shell("del trans_audio.mp3")
  shell("certutil -decode translated.txt trans_audio.mp3")
  shell("start trans_audio.mp3")
}