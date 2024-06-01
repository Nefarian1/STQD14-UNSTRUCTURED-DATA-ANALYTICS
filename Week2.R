eg1<-read.table(file.choose(),fill=T,header=F) #Data CG.txt
eg1[1,] 
eg2<-read.csv(file.choose(),header=F) #Data CG.csv
eg2[1,]

library(tm)
eg3<-c("Hi!","Welcome to STQD6114","Tuesday, 11-1pm")
mytext<-VectorSource(eg3)
mycorpus<-VCorpus(mytext)
inspect(mycorpus)
as.character(mycorpus[[1]])

#Example using VectorSource
eg4<-t(eg1) #From example 1
a<-sapply(1:7,function(x)
  trimws(paste(eg4[,x],collapse=" "),"right"))
mytext<-VectorSource(a)
mycorpus<-VCorpus(mytext)
inspect(mycorpus)
as.character(mycorpus[[1]])

#Example using DataFrameSource
eg5<-read.csv(file.choose(),header=F) #Using doc6.csv
docs<-data.frame(doc_id=c("doc_1","doc_2"),                 
                 text=c(as.character(eg5[1,]),as.character(eg5[2,])),                 
                 dmeta1=1:2,dmeta2=letters[1:2],stringsAsFactors=F)
mytext<-DataframeSource(docs)
mycorpus<-VCorpus(mytext)
inspect(mycorpus)
as.character(mycorpus[[1]])

#Example using DirSource
mytext<-DirSource("D:\RSTUDIO\R project\6114\wen jian\Attachment2") 
mycorpus<-VCorpus(mytext)
inspect(mycorpus)
as.character(mycorpus[[1]])
