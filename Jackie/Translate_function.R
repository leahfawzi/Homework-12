API_key <- "AIzaSyDMDSsfBjainQ3_ZDU1mBllY_uPMSo80WM"
translate <- function(input){
  text <- input
  source <- "zh-CN"
  target <- "en"
  body <- paste("{",
                "'q':'", text, "',", 
                "'source':'", source, "',",
                "'target':'", target, "',",
                "'format':'text',",  
                "}", sep="")
  
  base1 <- "https://translation.googleapis.com/language/translate/v2?key="
  url1 <- paste(base1, API_key, sep="")
  
  x1 <- httr::POST(url1, body = body)
  x1 <- jsonlite::fromJSON(rawToChar(x1$content))
  out <- x1$data$translations$translatedText
  return(out)
}
translate("ÄãºÃ")

text <- "ÄãºÃ"
translate(text)

API_key <- "AIzaSyDMDSsfBjainQ3_ZDU1mBllY_uPMSo80WM"

tts <- function(input){
  text <- input
  input <- paste("'input':{'text':'", text, "'}", sep="")
  voice <- "'voice':{'languageCode':'en-AU','name':'en-AU-Standard-A','ssmlGender':'FEMALE'}"
  output <- "'audioConfig':{'audioEncoding':'MP3'}"
  s_body <- paste("{", input, ",", voice, ",", output, "}", sep="")
  base_url <- "https://texttospeech.googleapis.com/v1/text:synthesize?key="
  url <- paste(base_url, API_key, sep="")
  x <- httr::POST(url, body = s_body)
  x <- jsonlite::fromJSON(rawToChar(x$content))
  x$audioContent
  Sys.setenv(output_string = x$audioContent)
  audio <- x$audioContent
  con <- file("sound_out2.txt", "w")
  writeLines(audio, con=con)
  close(con)
  shell("certutil -decode sound_out2.txt sound_out2.mp3")
  shell("start sound_out2.mp3")
  
}

tts(text)
