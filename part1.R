
eg1<-read.table(file.choose(),fill=T,header = F)#这行代码的作用是读取一个表格文件（例如.txt或.dat文件）
eg1[1,]
eg2<-read.csv(file.choose(),fill=T,header = F) #这行代码的作用是读取一个CSV文件
eg2[1,]


install.packages('tm')
library('tm')
install.packages('NLP')
library('NLP')

#using tm package
eg3<-c("Hi!","welcome to ATQD6114","Tuesday,11-1pm")#创建了一个字符向量
mytext<-VectorSource(eg3)#创建语料库
mycorpus<-VCorpus(mytext)#创建一个虚拟语料库包含mytext中得文本
inspect(mycorpus)#查看mycorpus的内容
as.character(mycorpus[[1]])#将mycorpus中的第一个文档转换为字符形式

#example using VectorSource
eg4<-t(eg1)  #from example 1 数据转置
a<-sapply(1:7,function(x)
  trimws(paste(eg4[,x],collapse=" "),"right"))
#对eg4的每一列进行处理，将每一列的元素合成一个字符，由空格分隔，删除右侧空格

mytext<-VectorSource(a)#创建语料库
mycorpus<-VCorpus(mytext)#创建虚拟语料库
inspect(mycorpus)#查看内容
as.character(mycorpus[[1]])#将第一个文档转为字符形式

#eg4b---GC.CSV
#EG4C--rISE.CSV
#Example using DataFrameSource
eg5<-read.csv(file.choose(),header=F) #Using doc6.csv
docs<-data.frame(doc_id=c("doc_1","doc_2"), 
                 text=c(as.character(eg5[1,]),as.character(eg5[2,])), 
                 dmeta1=1:2,dmeta2=letters[1:2],stringsAsFactors=F)
#创建了一个数据框docs，包含四个列：doc_id、text、dmeta1和dmeta2。text列包含eg5的前两行数据，转换为字符形式。
mytext<-DataframeSource(docs) #docs转换为一个数据框源（DataframeSource）对象，这是创建语料库的一种方式。
mycorpus<-VCorpus(mytext)
inspect(mycorpus)
as.character(mycorpus[[1]])#将mycorpus中的第一个文档转换为字符形式。

#例子
eg5b<-read.csv(file.choose(),header=F) 
docs<-data.frame(doc_id=c("doc_1","doc_2","doc_3","doc_4","doc_5","doc_6","doc_7"),
                 text=c(as.character(eg5b[1,]),as.character(eg5b[2,]),as.character(eg5b[3,]),as.character(eg5b[4,]),as.character(eg5b[5,]),as.character(eg5b[6,]),as.character(eg5b[7,])), 
                 dmeta1=1:7,dmeta2=letters[1:7],stringsAsFactors=F)
mytext<-DataframeSource(docs)
mycorpus<-VCorpus(mytext)
inspect(mycorpus)
as.character(mycorpus[[1]])


#在一个文件夹里提取第一个文件
mytext<-DirSource("E:/桌面/非结构/movies") 
mycorpus<-VCorpus(mytext)
inspect(mycorpus)
as.character(mycorpus[[1]])




