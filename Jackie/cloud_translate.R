#HW 12
setwd("~/Data Science Programming/HW/Homework-12-master")
API_key <- "AIzaSyDMDSsfBjainQ3_ZDU1mBllY_uPMSo80WM"

# GOOGLE CLOUD TRANSLATE
Sys.setlocale(category = "LC_CTYPE", locale = "Chinese")
install.packages("chinese.misc")
library(chinese.misc)

text <- "璐濆畞210涓斂鍏氬甯冨悎骞舵垚绔嬫敮鎸佹€荤粺濉旈殕鐨勬柊鏀垮厷 - 鏂板崕缃<91>"

title_i <- function(i){
  title <- title[i]
  return(title)
}
title_i(5)


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
out

  # GOOGLE CLOUD TEXT TO SPEECH
# supported voices/languages can be found here
# https://cloud.google.com/text-to-speech/docs/voices

text <- paste(out, collapse=" ")
text <- gsub("'", "", text)

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

con <- file("sound_out.txt", "w")
writeLines(audio, con=con)
close(con)

shell("certutil -decode sound_out.txt sound_out.mp3")

shell("start sound_out.mp3")
