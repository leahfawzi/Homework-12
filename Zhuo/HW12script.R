library(httr)

#the get_title function
#search for the title with some certain word included
get_title_word <- function(word_given){
  base <- "https://newsapi.org/v2/top-headlines?sources=le-monde&apiKey="
  end_base <- "98f4493768704ac986063cd67f82de67"
  url1 <- paste(base, end_base, sep="")
  
  x <- httr::GET(url=url1)
  x <- jsonlite::fromJSON(rawToChar(x$content))
  
  titles <- x$articles$title
  nhits <- titles[grep(word_given, titles)]
  return(nhits)
}


#translate function
#translate the title from French to Engilsh
translate_title <- function(nhits){
  API_key <- "AIzaSyDnv3wqborQ62nUDZr9tJb8Thc5i9znxOk"
  #translateR::getGoogleLanguages()
  
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
  url <- paste(base, API_key, sep="")
  
  x <- httr::POST(url, body = body)
  x <- jsonlite::fromJSON(rawToChar(x$content))
  out <- x$data$translations$translatedText
  return(out)
}


#Sound out MP3 function
#To get a MP3 version of the text translated and make it sounded out
sound_out_title <- function(out){
  API_key <- "AIzaSyDnv3wqborQ62nUDZr9tJb8Thc5i9znxOk"
  text <- paste(out, collapse=" ")
  text <- gsub("'", "", text)
  
  input <- paste("'input':{'text':'", text, "'}", sep="")
  voice <- "'voice':{'languageCode':'en-GB','name':'en-GB-Standard-C','ssmlGender':'FEMALE'}"
  output <- "'audioConfig':{'audioEncoding':'MP3'}"
  
  s_body <- paste("{", input, ",", voice, ",", output, "}", sep="")
  
  base_url <- "https://texttospeech.googleapis.com/v1/text:synthesize?key="
  url <- paste(base_url, API_key, sep="")
  
  x <- httr::POST(url, body = s_body)
  x <- jsonlite::fromJSON(rawToChar(x$content))
  Sys.setenv(output_string=x$audioContent)
  system("echo $output_string > LeMonde_out.txt")
  
  system("base64 --decode LeMonde_out.txt > LeMonde_out.mp3")
  system("afplay LeMonde_out.mp3")
  
}


#Sample display
#To get a recent title  with word "font" from LeMonde, 
#translate it into Enlish and make it sounded out with MP3 file
nhits <- get_title_word("font")
out <- translate_title(nhits)
sound_out_title(out)

#Original French title
nhits
#Translated English title
out







