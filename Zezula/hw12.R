setwd("/users/mateuszzezula/Box/1. First Semester/Programming for Data Science/Homework/")

library(pacman)
p_load(httr, magrittr, dplyr)

# KEYS -- ultimately decided abstract the API keys.

KEYS <- function() {
  API_key.news <- "c6c10679081f4b43ab4352aea936e71b"
  API_key.google <- "AIzaSyC__Z4A1CtIarOddPbhBnHcy_weBGIulw4"
  google.translate.base <- "https://translation.googleapis.com/language/translate/v2?key="
  google.speech.base <- "https://texttospeech.googleapis.com/v1/text:synthesize?key="
  
  url.google.translate <- paste0(google.translate.base, API_key.google)
  url.google.speech <- paste0(google.speech.base, API_key.google)
  
  return(list(API_key.news = API_key.news,
              google.translate = url.google.translate,
              google.speech  = url.google.speech))
}
KEYS()$google.speech

# en.translator -- Takes character vectors and returns English translation as df.
en.translator <- function(url, text) {
  source <- "fr"
  target <- "en"
  df_output <- setNames(data.frame(matrix(ncol = 1, nrow = length(text))), "Translated_Titles")
  for (i in 1:length(text)) {
    body <- paste("{",
                  "'q':'", text[i], "',", 
                  "'source':'", source, "',",
                  "'target':'", target, "',",
                  "'format':'text'",  
                  "}", sep = "")
    z <- httr::POST(url$google.translate, body = body)
    z <- jsonlite::fromJSON(rawToChar(z$content))
    df_output[i, "Translated_Titles"] <- z$data$translations$translatedText
  }
  return(df_output)
}
sample.text <- "Merci beaucoup!"
en.translator(KEYS(), sample.text)

# create.news.url -- Serves as the foundation for df.article().
create.news.url <- function(url, date) {
  base <- "https://newsapi.org/v2/everything?sources=le-monde&pageSize=100&apiKey="
  start.date <- as.Date(date, format = "%Y-%m-%d")
  end.date <- start.date + 1
  url.start <- paste0("&from=", start.date)
  url.end <- paste0("&to=", end.date)
  url <- paste0(base, url$API_key.news, url.start, url.end, "&sortBy=popularity")
  return(url)
}
create.news.url(KEYS(), "2018-11-15")

# df.article -- returns df of top 100 article on specified date. (Note: A function that returns a 
# data.frame between any two dates, though instructive, is beyond the scope of this homework.)
df.article <- function(url, start.date) {
  url.input <- create.news.url(url, start.date)
  z <- httr::GET(url.input)
  z <- jsonlite::fromJSON(rawToChar(z$content))
  z <- z$articles
  return(z)
}
head(df.article(KEYS(), "2018-11-15"))

# get.title -- returns translated titles that contain specified keyword.
get.title <- function(url, start.date, keyword) {
  df <- df.article(url, start.date)
  title <- df$title
  en.title <- en.translator(url, title)
  output <- dplyr::filter(en.title, grepl(keyword, Translated_Titles))
  return(output)
}
get.title(KEYS(), "2018-11-15", "California")

newspaper.text <- get.title(KEYS(), "2018-11-15", "California")[1,"Translated_Titles"]
newspaper.text

read.english <- function(url, text) {
  input <- paste("'input':{'text':'", text, "'}", sep="")
  voice <- "'voice':{'languageCode':'en-GB','name':'en-GB-Standard-C','ssmlGender':'FEMALE'}"
  output <- "'audioConfig':{'audioEncoding':'MP3'}"
  s.body <- paste("{", input, ",", voice, ",", output, "}", sep="")
  
  z <- httr::POST(url$google.speech, body = s.body) 
  z <- jsonlite::fromJSON(rawToChar(z$content))

  Sys.setenv(output_string = z$audioContent)
  system("echo $output_string > sound_out.txt")
  system("base64 --decode sound_out.txt > sound_out.mp3")
  system("afplay sound_out.mp3")
}