library(tm)
install.packages("SentimentAnalysis")
install.packages("sentimentr")
install.packages("RWeka")
install.packages("RTextTools")
install.packages("e1071")
install.packages("twitteR")
install.packages("plyr")
install.packages("ROAuth")
install.packages("stringr")
install.packages("ggplot2")

library(twitteR) ### for fetching the tweets
library(plyr) ## for breaking the data into manageable pieces
library(ROAuth) # for R authentication
library(stringr) # for string processing
library(ggplot2) # for plotting the results

reqURL <- "https://api.twitter.com/oauth/request_token"
accessURL <- "http://api.twitter.com/oauth/access_token"
authURL <- "http://api.twitter.com/oauth/authorize"

api_key = "FyscHZCkHvDSHAlBFEz9XjJD2"
api_secret = "6iUVrUP6X2vqNNNzymxGYYCsw12VPMVYJmiA9brJcmPatQvhsi"
access_token = "902840726739869696-NBb9mKLRvNtFxjBIvdkviUlXtGvFqpp"
access_token_secret = "3Hb7dLCgZiDv37oubFl63sN6F1y0nNXZKJdmqJhesQTYB"
setup_twitter_oauth(api_key, api_secret, access_token, access_token_secret)

setwd("//172.17.0.4/Marketing & Analytics/Projects/News Tagging/Sneha")
positive=read_excel("//172.17.0.4/Marketing & Analytics/Projects/News Tagging/Sneha/positive.xlsx",  col_names = FALSE) 
positive=as.character(positive$X__1)
negative=read_excel("//172.17.0.4/Marketing & Analytics/Projects/News Tagging/Sneha/negative.xlsx",   col_names = FALSE)

posText <- read.delim("positive-words.txt",header = FALSE,stringsAsFactors = FALSE)
posText <- posText$V1 
posText <- unlist(lapply(posText, function(x) { str_split(x, "\n") }))
negText <- read.delim("negative-words.txt", header = FALSE,stringsAsFactors=FALSE)
negText <- negText$V1 
negText <- unlist(lapply(negText, function(x) { str_split(x, "\n") }))
pos.words = c(posText, 'upgrade')
neg.words = c(negText, 'wtf', 'wait', 'waiting','epicfail', 'mechanical')

delta_tweets = searchTwitter('@delta', n=500)
jetblue_tweets = searchTwitter('@jetblue', n=500)
united_tweets = searchTwitter('@united', n=500)

delta_txt = sapply(delta_tweets, function(t) t$getText() )
jetblue_txt = sapply(jetblue_tweets, function(t) t$getText() )
united_txt = sapply(united_tweets, function(t) t$getText() )

noof_tweets = c(length(delta_txt), length(jetblue_txt),length(united_txt))
airline<- c(delta_txt,jetblue_txt,united_txt)

score.sentiment = function(sentences, pos.words, neg.words, .progress='none')
{
  # Parameters
  # sentences: vector of text to score
  # pos.words: vector of words of positive sentiment
  # neg.words: vector of words of negative sentiment
  # .progress: passed to laply() to control of progress bar
  # create a simple array of scores with laply
  scores = laply(sentences,
                 function(sentence, pos.words, neg.words)
                 {
                   # remove punctuation
                   sentence = gsub("[[:punct:]]", "", sentence)
                   # remove control characters
                   sentence = gsub("[[:cntrl:]]", "", sentence)
                   # remove digits?
                   sentence = gsub('\\d+', '', sentence)
                   # define error handling function when trying tolower
                   tryTolower = function(x)
                   {
                     # create missing value
                     y = NA
                     # tryCatch error
                     try_error = tryCatch(tolower(x), error=function(e) e)
                     # if not an error
                     if (!inherits(try_error, "error"))
                       y = tolower(x)
                     # result
                     return(y)
                   }
                   # use tryTolower with sapply 
                   sentence = sapply(sentence, tryTolower)
                   # split sentence into words with str_split (stringr package)
                   word.list = str_split(sentence, "\\s+")
                   words = unlist(word.list)
                   # compare words to the dictionaries of positive & negative terms
                   pos.matches = match(words, pos.words)
                   neg.matches = match(words, neg.words)
                   # get the position of the matched term or NA
                   # we just want a TRUE/FALSE
                   pos.matches = !is.na(pos.matches)
                   neg.matches = !is.na(neg.matches)
                   # final score
                   score = sum(pos.matches) - sum(neg.matches)
                   return(score)
                 }, pos.words, neg.words, .progress=.progress )
  # data frame with scores for each sentence
  scores.df = data.frame(text=sentences, score=scores)
  return(scores.df)
}

scores = score.sentiment(airline, pos.words,neg.words , .progress='text')
scores$airline = factor(rep(c("Delta", "JetBlue","United"), noof_tweets))
scores$positive <- as.numeric(scores$score >0)
scores$negative <- as.numeric(scores$score <0)
scores$neutral <- as.numeric(scores$score==0)

delta_airline <- subset(scores, scores$airline=="Delta")
jetblue_airline <- subset(scores,scores$airline=="JetBlue")
united_airline <- subset(scores,scores$airline=="United")

delta_airline$polarity <- ifelse(delta_airline$score >0,"positive",ifelse(delta_airline$score < 0,"negative",ifelse(delta_airline$score==0,"Neutral",0)))
jetblue_airline$polarity <- ifelse(jetblue_airline$score >0,"positive",ifelse(jetblue_airline$score < 0,"negative",ifelse(jetblue_airline$score==0,"Neutral",0)))
united_airline$polarity <- ifelse(united_airline$score >0,"positive",ifelse(united_airline$score < 0,"negative",ifelse(united_airline$score==0,"Neutral",0)))






