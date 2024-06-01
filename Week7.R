##############################################2
#install.packages("tm")
library(tm)

mytext<-DirSource("D:/学校/出国/课程/STQD6114/TextMining")
docs<-VCorpus(mytext)
docs <- tm_map(docs,content_transformer(tolower))

docs <- tm_map(docs, removePunctuation)
docs <- tm_map(docs, removeNumbers)
docs <- tm_map(docs, removeWords, stopwords("english"))
docs <- tm_map(docs, stripWhitespace)

tdm <- DocumentTermMatrix(docs) #Create document term matrix
tdm

#Present text data numerically, weighted TF-IDF
tdm.tfidf <- weightTfIdf(tdm)
tdm.tfidf <- removeSparseTerms(tdm.tfidf, 0.999)
tfidf.matrix <- as.matrix(tdm.tfidf)

# Cosine distance matrix (useful for specific clustering algorithms)
#install.packages("proxy")
library(proxy)
dist.matrix <- dist(tfidf.matrix, method = "cosine")
truth.K=2
#Perform clustering
#install.packages("dbscan")
library(dbscan)
clustering.kmeans <- kmeans(tfidf.matrix, truth.K)
clustering.hierarchical <- hclust(dist.matrix, method = "ward.D2")
clustering.dbscan <- hdbscan(dist.matrix, minPts=10)

library(cluster)
clusplot(as.matrix(dist.matrix),clustering.kmeans$cluster,color=T,shade=T,labels=2,lines=0)
plot(clustering.hierarchical)
rect.hclust(clustering.hierarchical,2)
plot(as.matrix(dist.matrix),col=clustering.dbscan$cluster+1L)

#Combine results
master.cluster <- clustering.kmeans$cluster
slave.hierarchical <- cutree(clustering.hierarchical, k = truth.K) 
slave.dbscan <- clustering.dbscan$cluster

table(master.cluster)
table(slave.hierarchical)
table(slave.dbscan)

#plotting results
library(colorspace)
points <- cmdscale(dist.matrix, k = 2) 
palette <- diverge_hcl(truth.K) # Creating a colorpalette, need library(colorspace)
#layout(matrix(1:3,ncol=1))
plot(points, main = 'K-Means clustering', col = as.factor(master.cluster), 
     mai = c(0, 0, 0, 0), mar = c(0, 0, 0, 0), 
     xaxt = 'n', yaxt = 'n', xlab = '', ylab = '') 
plot(points, main = 'Hierarchical clustering', col = as.factor(slave.hierarchical), 
     mai = c(0, 0, 0, 0), mar = c(0, 0, 0, 0), 
     xaxt = 'n', yaxt = 'n', xlab = '', ylab = '') 
plot(points, main = 'Density-based clustering', col = as.factor(slave.dbscan), 
     mai = c(0, 0, 0, 0), mar = c(0, 0, 0, 0), 
     xaxt = 'n', yaxt = 'n', xlab = '', ylab = '')

#Elbow plot
#accumulator for cost results
cost_df <- data.frame()
#run kmeans for all clusters up to 100
for(i in 1:20){
  #Run kmeans for each level of i, allowing up to 100 iterations for convergence
  kmeans<- kmeans(x=tfidf.matrix, centers=i, iter.max=100)
  #Combine cluster number and cost together, write to df
  cost_df<- rbind(cost_df, cbind(i, kmeans$tot.withinss))
}
names(cost_df) <- c("cluster", "cost")
plot(cost_df$cluster, cost_df$cost)
lines(cost_df$cluster, cost_df$cost)


#######################################################
dataframe <- data.frame(ID=character(), 
                        datetime=character(), 
                        content=character(), 
                        label=factor())
#https://archive.ics.uci.edu/static/public/186/wine+quality.zip
#https://archive.ics.uci.edu/ml/machine-learningdatabases/00438/Health-News-Tweets.zip
source.url <- 'https://archive.ics.uci.edu/ml/machine-learningdatabases/00438/Health-News-Tweets.zip'
target.directory <- '/tmp/clustering-r'
temporary.file <- tempfile()
download.file(source.url, temporary.file)
unzip(temporary.file, exdir = target.directory)

# Reading the files 
target.directory <- paste(target.directory, 'Health-Tweets', sep= '/')
files <- list.files(path = target.directory, pattern='.txt$')

# Filling the dataframe by reading the text content
for (f in files) { 
  news.filename = paste(target.directory , f, sep ='/') 
  news.label <- substr(f, 0, nchar(f) - 4) # Removing the 4 last characters => '.txt'
  news.data <- read.csv(news.filename, 
                        encoding = 'UTF-8', 
                        header = FALSE, 
                        quote = "", 
                        sep = '|', 
                        col.names = c('ID', 'datetime', 'content'))
  # Trick to handle native split problem (cf. notebook for detail)
  news.data <- news.data[news.data$content != "", ]
  news.data['label'] = news.label # We add the label of the tweet
  # Massive data loading memory problem : only loading a few (cf. notebook for detail)
  news.data <- head(news.data, floor(nrow(news.data) * 0.05))
  dataframe <- rbind(dataframe, news.data) # Row appending 
}

unlink(target.directory, recursive = TRUE) # Deleting the temporary directory

#Data prep
sentences <- sub("http://([[:alnum:]|[:punct:]])+", '', dataframe$content)
corpus <- Corpus(VectorSource(sentences))

# Cleaning up 
# Handling UTF-8 encoding problem from the dataset 
#for Mac corpus.cleaned <- tm::tm_map(corpus, function(x) iconv(x, to='UTF-8-MAC', sub='byte')) 
corpus.cleaned <- tm_map(corpus, function(x) iconv(enc2utf8(x), sub = "byte"))
corpus.cleaned <- tm_map(corpus.cleaned, removeWords, stopwords('english')) # Removing stop-words 
corpus.cleaned <- tm_map(corpus, stemDocument, language = "english") # Stemming the words 
corpus.cleaned <- tm_map(corpus.cleaned, stripWhitespace) # Trimming excessive whitespaces
strwrap(corpus.cleaned[3158])

#Present text data numerically, weighted TF-IDF
tdm <- DocumentTermMatrix(corpus.cleaned) 
tdm.tfidf <- weightTfIdf(tdm)
tdm.tfidf <- removeSparseTerms(tdm.tfidf, 0.999) 
tfidf.matrix <- as.matrix(tdm.tfidf) 
inspect(tdm)

# Cosine distance matrix (useful for specific clustering algorithms) 
library(proxy)
dist.matrix = dist(tfidf.matrix, method = "cosine")

truth.K=5
#Perform clustering
library(dbscan)
clustering.kmeans <- kmeans(tfidf.matrix, truth.K) 
clustering.hierarchical <- hclust(dist.matrix, method = "ward.D2") 
clustering.dbscan <- hdbscan(dist.matrix, minPts = 10)

library(cluster)
clusplot(as.matrix(dist.matrix),clustering.kmeans$cluster,color=T,shade=T,labels=2,lines=0)
plot(clustering.hierarchical)
rect.hclust(clustering.hierarchical,2)
plot(as.matrix(dist.matrix),col=clustering.dbscan$cluster+1L)

#Combine results
master.cluster <- clustering.kmeans$cluster
slave.hierarchical <- cutree(clustering.hierarchical, k = truth.K) 
slave.dbscan <- clustering.dbscan$cluster

table(master.cluster)
table(slave.hierarchical)
table(slave.dbscan)
#plotting combined results
library(colorspace)
points <- cmdscale(dist.matrix, k = 2) 
palette <- diverge_hcl(truth.K) # Creating a color palette, need library(colorspace)
layout(matrix(1:3,ncol=1))

plot(points, main = 'K-Means clustering', col = as.factor(master.cluster), 
     mai = c(0, 0, 0, 0), mar = c(0, 0, 0, 0), 
     xaxt = 'n', yaxt = 'n', xlab = '', ylab = '') 
plot(points, main = 'Hierarchical clustering', col = as.factor(slave.hierarchical), 
     mai = c(0, 0, 0, 0), mar = c(0, 0, 0, 0), 
     xaxt = 'n', yaxt = 'n', xlab = '', ylab = '') 
plot(points, main = 'Density-based clustering', col = as.factor(slave.dbscan), 
     mai = c(0, 0, 0, 0), mar = c(0, 0, 0, 0), 
     xaxt = 'n', yaxt = 'n', xlab = '', ylab = '')

#Elbow plot
#accumulator for cost results
cost_df <- data.frame()
#run kmeans for all clusters up to 100
for(i in 1:1000){
  #Run kmeans for each level of i, allowing up to 100 iterations for convergence
  kmeans<- kmeans(x=tfidf.matrix, centers=i, iter.max=100)
  #Combine cluster number and cost together, write to df
  cost_df<- rbind(cost_df, cbind(i, kmeans$tot.withinss))
}
names(cost_df) <- c("cluster", "cost")
plot(cost_df$cluster, cost_df$cost)
lines(cost_df$cluster, cost_df$cost)


##############################################3

library(tm) # for text mining
library(SnowballC) # for text stemming
library(wordcloud) # word-cloud generator
library(RColorBrewer) # color palettes
library(syuzhet) # for sentiment analysis
library(ggplot2) # for plotting graphs
# Read the text file from local machine , choose file interactively
text <- readLines(file.choose())
# Load the data as a corpus
docs <- Corpus(VectorSource(text))
#Replacing "/", "@" and "|" with space
toSpace <- content_transformer(function (x , pattern ) gsub(pattern, " ", x))
docs <- tm_map(docs, toSpace, "/")
docs <- tm_map(docs, toSpace, "@")
docs <- tm_map(docs, toSpace, "\\|")
docs <- tm_map(docs, content_transformer(tolower)) 
docs <- tm_map(docs, removeNumbers) 
docs <- tm_map(docs, removeWords, stopwords("english"))
docs <- tm_map(docs, removeWords, c("s", "company","team")) 
docs <- tm_map(docs, removePunctuation)
docs <- tm_map(docs, stripWhitespace)
docs <- tm_map(docs, stemDocument)
# Build a term-document matrix
dtm <- TermDocumentMatrix(docs)
dtm_m <- as.matrix(dtm)
dtm_v <- sort(rowSums(dtm_m),decreasing=TRUE) # Sort by descending value of frequency
dtm_d <- data.frame(word = names(dtm_v),freq=dtm_v)
head(dtm_d, 5) # Display the top 5 most frequent words
# Plot the most frequent words
barplot(dtm_d[1:5,]$freq, las = 2, names.arg = dtm_d[1:5,]$word,
        col ="lightgreen", main ="Top 5 most frequent words",
        ylab = "Word frequencies")
#generate word cloud
set.seed(1234)
wordcloud(words = dtm_d$word, freq = dtm_d$freq, min.freq = 5,
          max.words=100, random.order=FALSE, rot.per=0.40, 
          colors=brewer.pal(8, "Dark2"))
# Word Association
findAssocs(dtm, terms = c("good","work","health"), corlimit = 0.25) # Find associations 
findAssocs(dtm, terms = findFreqTerms(dtm, lowfreq = 50), corlimit = 0.25) # Find associations for words that occur at least 50 times

## Sentiment scores
# regular sentiment score using get_sentiment() function and method of your choice
# please note that different methods have different scales
syuzhet_vector <- get_sentiment(text, method="syuzhet")
head(syuzhet_vector)
head(syuzhet_vector,10) # see the first 10 elements of the vector
summary(syuzhet_vector)
# bing
bing_vector <- get_sentiment(text, method="bing")
head(bing_vector)
summary(bing_vector)
#afinn
afinn_vector <- get_sentiment(text, method="afinn")
head(afinn_vector)
summary(afinn_vector)
#nrc
nrc_vector <- get_sentiment(text, method="nrc")
head(nrc_vector)
summary(nrc_vector)
#compare the first row of each vector using sign function
rbind(
  sign(head(syuzhet_vector)),
  sign(head(bing_vector)),
  sign(head(afinn_vector))
)

## Emotion classification
# run nrc sentiment analysis to return data frame with each row classified as one of the following
# emotions, rather than a score : 
# anger, anticipation, disgust, fear, joy, sadness, surprise, trust 
# and if the sentiment is positive or negative
d<-get_nrc_sentiment(text)
head (d,10) # head(d,10) - just to see top 10 lines
#Visualization
td<-data.frame(t(d)) #transpose
td_new <- data.frame(rowSums(td)) #The function rowSums computes column sums across rows for each level of a grouping variable.
names(td_new)[1] <- "count" #Transformation and cleaning
td_new <- cbind("sentiment" = rownames(td_new), td_new)
rownames(td_new) <- NULL
td_new2<-td_new[1:8,]
#Plot 1 - count of words associated with each sentiment
quickplot(sentiment, data=td_new2, weight=count, geom="bar",fill=sentiment,ylab="count")+ggtitle("Survey sentiments")
#Plot 2 - count of words associated with each sentiment, expressed as a percentage
barplot(
  sort(colSums(prop.table(d[, 1:8]))), 
  horiz = TRUE, 
  cex.names = 0.7, 
  las = 1, 
  main = "Emotions in Text", xlab="Percentage"
)


