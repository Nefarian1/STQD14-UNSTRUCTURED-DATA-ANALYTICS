######################## Text Exploration ##################

#Regular expression - a languange to identify pattern/sequence of character
# 正则表达式——一种识别模式/字符序列的语言

##grep functions (without use any package)  Grep函数(不使用任何包)
ww<-c("statistics","estate","castrate","catalyst","Statistics")
ss<-c("I like statistics","I like bananas","Estates and statues are expensive")

#1st function - grep() -give the location of pattern 给出pattern的位置
grep(pattern="stat",x=ww) #x is the document, will return the location only 找到x中stat的位置，区分大小写
grep(pattern="stat",x=ww,ignore.case=T) #ignore the capital/small letter, will return the location only 找到stat,不区分大小写
grep(pattern="stat",x=ww,ignore.case=T,value=T) #ignore the capital/small letter, return to that particular words 不区分大小写并找到整个词

#2nd function - grepl() - give logical expression 给出逻辑表达  有这一词汇的TRUE，没有FALSE
grepl(pattern="stat",x=ww) #Return true/false
grepl(pattern="stat",x=ss)

#3rd FALSE
#return a vector of two attributes; position of the first match and its length
#if not, it returns -1
#regexpr()函数用于搜索字符串向量中的正则表达式匹配，并返回每个匹配的开始位置和长度。没有就是-1
regexpr(pattern="stat",ww)
regexpr(pattern="stat",ss)#空格也算一个字符

#4th function - gregexpr()
gregexpr(pattern="stat",ss)#第二句有几stat,都会标出位置和长度

#5th function - regexec()
regexec(pattern="(st)(at)",ww)#每个子串的stat,st,at的位置和长度

#6th function - sub()
#替换元素，不区分大小写，将所有第一个stat都换成STAT
sub("stat","STAT",ww,ignore.case=T)
sub("stat","STAT",ss,ignore.case=T)

#7th function - gsub()  将所有的stat都换成STAT
gsub("stat","STAT",ss,ignore.case=T)

#与sub()函数不同，gsub()函数会替换所有匹配到的模式，而不仅仅是第一个。
#这使得gsub()非常适合用于清理或转换包含多个匹配项的文本数据。


library(stringr)
words #dataset related to words 词汇相关数据集
fruit #dataset fruit available in package stringr 数据集果实在包字符串中可用
sentences #dataset sentences 数据集的句子

#Common function in package stringr
#stringr中的常用函数
str_length("This is STQD6114") #str_length()-gives the length of that string 给出该字符串的长度
#字符串"This is STQD6114"包含16个字符，空格也算

str_split(sentences," ") #str_split()-split the function by space & return the list
#根据空格字符（" "）将sentences向量中的每个字符串分割成单词

str_c("a","b","c") #combine string to become a long ist
#将abc组合在一起，由于没有指定分隔符，结果abc
str_c("A",c("li","bu","ngry")) #combine A to each vector
#将A和后面每一个变量分别组合在一起
str_c("one for all","All for one",sep=",") #combine these string and separate by comma
#将这两句话组合在一起，用，分隔
str_c("one for all","All for one",collapse=",") #combine the string to be one sentences
#将两个字符串向量合成一个字符串

x<-c("Apple","Banana","Pear")

#str_sub() gives subset
str_sub(x,1,3) #Gives from 1st to 3rd letter 给出第1到第3个字母
str_sub(x,-3,-1) #Gives the last three letter 给出后三个字母

str_to_upper(x) #Return the string to upper case letter 全变大写
str_to_lower(x) #Return the string to lower case letter  全变小写
str_to_title("unstructured data analytics") #Return upper case letter to the string 
#将字符串转换为标题格式，标题格式中每一个单词首字母会大写，其余字母保持小写
str_to_title(x)

#Note: str_view give the output in another browser
#搜索字符串fruit中的"an"模式，并以可视化的方式显示匹配的部分
str_view(fruit,"an") #view the pattern (for the first time) of dataset 
#显示所有匹配的部分，而不仅仅是第一个匹配的部分
str_view_all(fruit,"an") #view all pattern (including repeated observation)

# "." refers to anything . 可以表示任何东西
str_view(fruit,".a.") #refers to dataset fruit, find any fruit that have letter a
str_view(x,".a.")
str_view(sentences,".a.") #refers to dataset sentences, find any sentence that have letter a that is seen 1st time 
#参考数据集的句子，找到任何含有字母a且第一次出现的句子

#找到符号(')，加反冲(\)或不加都可以
str_view_all(sentences,"\'") #find the symbol('), put backlash(\) or not is ok 

#Anchors - ^ refers to the start of a string, $ refers to the end of a string
#^指向字符串的开始，$指向字符串的结束
str_view(x,"^A") #找到所有A开头的字符串
str_view(x,"a$") #找到所有a结尾的字符串
str_view(fruit,"^a") #find the fruit that has first word "a" in fruit dataset
str_view(fruit,"a$") #find the fruit that has end word "a" in fruit dataset
str_view(fruit,"^...$") #find the fruits with 3 character(letter), doesn't matter what letter as a start and end
# 匹配所有长度为3的字符串。。。表示不管是三个什么字符

#Note:\\b-boundary, \\d-digits, \\s-white space (space,tab,newlines).
ee<-c("sum","summarize","rowsum","summary")

str_view(ee,"sum") # ee中所有包含 sum的字符串

#ee 中 所有"sum"开头的字符串
str_view(ee,"\\bsum") #if let say we want to put boundaries, means the earlier/start words with sum. So, rowsum is not included

#ee 中 所有以'sum'结尾的字符串
str_view(ee,"sum\\b") #if let say we want to put boundaries, means the end words with sum.

# ee中所有以sum 开头和结尾的字符串
str_view(ee,"\\bsum\\b")

str_view(sentences,"\\d") #find digits in dataset sentences 找数据集句子中的数字
#\\d 表示任意数字字符 0-9

ss<-c("This is a class with students","There are 18 students","This class is from 11.00 am")
#\\d所有数字
str_view(ss,"\\d") #Find any sentences that have digits
#\\s 所有空格
str_view(ss,"\\s") #Find any sentences that have white space

str_view_all(fruit,"[abc]") #[abc] match to all a/b/c. Can also use "(a|b|c)"
#包含abc 任意一个字母

str_view_all(fruit,"^[abc]") #any fruit that is started with any a/b/c
#以abc开头

str_view_all(fruit,"^(g|h)")#以g或h开头的字符串

#repetition 重复
#? means 0 or 1 repetition  ？ 表示0或1次重复
#+ means 1 or more repetition  +表示重复1次或更多
#* means 0 or more repetition  *表示0次或以上的重复
#{n} means n times repetition  {n}表示重复n次
#{n,} means n or more times repetition  {n，}表示重复n次或以上
#{,m} means m or less times repetition  {，m}表示重复次数小于等于m次
#{n,m} means between n to m times repetition  {n,m}表示重复n到m次

ex<-"aabbbccddddeeeee"
str_view(ex,"aab?") #gives 0 or 1 aab  aab字符串出现0次或者1次
str_view(ex,"aac?") #gives 0 or 1 aac. The output gives aa because can be 0
str_view(ex,"(a|d){2}") #Find a or d that occur 2 times  连续两个a或者连续两个b 的字符串
str_view_all(ex,"de+") #Find d and e, the letter e can be once or more 字符串de后面跟着连续多个e
str_view_all(ex,"de+?") #Find d and e, and gives the shortest  0或1个e
str_view_all(ss,"\\d+") #Find digits at least once 包含连续或者多个任意数字字符的字符串
str_view_all(ss,"\\d{2,}") #Find digits, 2 times or more 至少出现两次

#grouping and backreferencing 分组和反向引用
#以"a"开头，后面跟着任意一个字符，然后再次出现"a"的字符串a v a
str_view(fruit,"(a).\\1") #Find a, after a any letter (one dot=one letter),then repeat a once
#"a"开头，后面跟着一个或多个任意字符，然后再次出现"a"的字符串a stsum a
str_view(fruit,"(a).+\\1") #Follow above, between a must have more than one repetition (the longest repetition)
#后面跟着任意一个字符，然后再次出现原始的"a"和后面的字符的字符串 anan/alal
str_view(fruit,"(a)(.)\\1\\2") #Find a, followed by any characters,then repeat a gain, then repeat any characters
#匹配所有以任意两个字符开头，然后再次出现这两个字符的顺序相反的字符串。ep pe
str_view(fruit,"(.)(.)\\2\\1") #Find any two character, repeat the second one first, then repeat the first one

#Exercise using other dataset, eg. words
str_view(words,"^(.).*\\1$") #Find any character, that is started with anything, and have any character inside (can be 0/more because 
#use *),and end with the 1st letter开始是任意字符，结尾是第一个字符  a meric a
str_view(words,"(..).*\\1") #Find a pair of characters that is repeat in that word (will end with that pair of words)
#找到一对重复的字符，并以这对结束 re fo re

#Other function in package str

#检查每个字符包不包含‘e’,包含的是TRUE 不包含是FALSE
str_detect(fruit,"e") #Return true/false that consists of words that have e inside

#检查是否以 aeiou 任意一个结尾，是TRUE
str_detect(fruit,"[aeiou]$") #a/e/i/o/u at the end

#统计fruit 中每个字符串中 e出现的次数
str_count(fruit,"e") #Cound the letter e in the word
fruit[5] #just check the fruit no 5

#替换，将所有首字母a替换成A
str_replace(fruit,"^a","A") #replace a with capital letter A

#替换，将所有首字母a替换成A，e 替换成E
str_replace_all(fruit, c("^a"="A", "^e"="E")) #replace a with capital letter A, e with E


#####
#Other function
library(stringr)
library(tidyverse)

a<-"Hello World"
a<-'Hello World'
a<-"Strings are \"scary\""
writeLines(a)
a<-"\u00b5" #微米（µ）的符号 #represent specific Unicode. Try to google other Unicode, eg. alpha, lambda, etc.
writeLines(a) #字符串写入到标准输出

### Cleaning and preprocessing # 清洗和预处理

library(tm)
library(NLP)
#docs<-VCorpus(VectorSource(sentences))
docs<-Corpus(VectorSource(sentences))#创建一个语料库对象

#第31个文档转换为字符串，并将其写入到标准输出
writeLines(as.character(docs[[30]]))

getTransformations()
#getTransformations()函数是r语言中的一个函数，用于文本预处理中
#可用的转换函数列表，转换函数包括：
#removeNumbers：从文本文档中移除数字。
#removePunctuation：从文本文档中移除标点符号。
#removeWords：从文本文档中移除特定的单词。
#stemDocument：对文本文档进行词干提取，即将词汇归约到其词根形式。
#stripWhitespace：从文本文档中移除多余的空白字符。

#Create custom transformation 创建自定义转换
toSpace<-content_transformer(function(x,pattern){return(gsub(pattern," ",x))})
#content_transformer()函数接收一个函数作为参数，这个函数定义了如何修改文本内容。
#传递给content_transformer()的函数接收两个参数：
#x和pattern。x是要被修改的文本内容，pattern是要匹配的模式。
#函数内部使用gsub()函数将x中所有匹配pattern的部分替换为空格，并返回修改后的文本。

as.character(docs[[133]]) #check line 133  转换为字符串
docs<-tm_map(docs,toSpace,"-")#它的作用是将文本中所有匹配特定模式（在这里是"-"）的部分替换为空格，清理文本数据
as.character(docs[[133]])

docs<-tm_map(docs,removePunctuation) #移除文本中所有标点符号
docs<-tm_map(docs,content_transformer(tolower))#将内容全部小写
docs<-tm_map(docs,removeNumbers) #移除所有数字
docs<-tm_map(docs,removeWords,stopwords("english"))#移除所有英语停用词 #remove stop words

as.character(docs[[2]])

docs<-tm_map(docs,removeWords,"gp")#从文本文档中移除指定的词汇，移除gp
docs<-tm_map(docs,stripWhitespace) #移除多余空白字符

library(SnowballC)#词干提取算法
docs2<-tm_map(docs,stemDocument) #for stemming the documents
#对文本文档进行词干提取（stemming），将词汇归约到它们的词干形式。
#词干提取是文本预处理的一个重要步骤，它可以帮助减少文本数据中的噪声，
#使得文本分析更加集中于文本的语义内容。
install.packages('textstem')
library(textstem)
docs3<-stem_strings(docs) #字符向量中的每个字符串进行词干提取，即将词汇归约到它们的词干形式
a<-unlist(str_split(docs3,"[,]"))#将docs3中的每个字符串按照逗号（,）进行分割，并将结果转换为一个向量
docs4<-lemmatize_strings(docs) #词形还原则是将词汇的不同形式（如动词的过去时、现在时等）归约到它们的基本形式
b<-unlist(str_split(docs4,"[,]"))

dtm<-DocumentTermMatrix(docs) #词汇矩阵，统计每个词汇出现得频率
inspect(dtm[1:2,1:100]) #显示矩阵前2行和前100列得信息
freq<-colSums(as.matrix(dtm))#统计每个词汇在语料库中出现得频率
length(freq)
ord<-order(freq,decreasing=T)#按照降序排列，即最大的频率在前，最小的频率在后
head(ord)
freq[head(ord)] #显示出现最多得词汇

dtm<-DocumentTermMatrix(docs,control=list(wordLengths=c(2,20),
                                          bounds=list(global=c(2,30))))
#只显示长度在2到20之间得词汇，过滤掉过长词汇，选择频率2到30次得词汇

inspect(dtm[1:2,1:100])
freq<-colSums(as.matrix(dtm))
length(freq)
ord<-order(freq,decreasing=T)
head(ord)
freq[head(ord)]

#once we have all above, we can insert to data frame 插入到数据帧
wf<-data.frame(names(freq),freq) #创建一个数据框，包含词汇和总出现频率
names(wf)<-c("TERM","FREQ") #设置列名
head(wf)

findFreqTerms(dtm,lowfreq=10)#找频率大于10的词汇，可以快速识别关键词汇
findAssocs(dtm,"get",0.3) #找到和get相关联的词汇，关联大于0.3才返回

library(ggplot2)
Subs<-subset(wf,FREQ>=10)#从数据集wf中筛选出FREQ值大于或等于10的子集，并将其存储在变量Subs中。
ggplot(Subs,aes(x=TERM,y=FREQ))+geom_bar(stat="identity")+
  theme(axis.text.x=element_text(angle=45,hjust=1))#创建一个条形图，展示Subs数据集中TERM与FREQ之间的关系
ggplot(wf,aes(x=TERM,y=FREQ))+geom_bar(stat="identity")+
  theme(axis.text.x=element_text(angle=45,hjust=1)) #Show all, include terms that hv small freq

library(wordcloud) #生成词云
wordcloud(names(freq),freq) #in general #创建词云
wordcloud(names(freq),freq.min.freq=10) #if we want to focus on the min freq of 10#词云只包含频率大于10的词
wordcloud(names(freq),freq,colors=brewer.pal(8,"Darker"))#词云使用brewer.pal(8,"Darker")生成的颜色调色板
wordcloud(names(freq),freq,colors=brewer.pal(12,"Paired"))#brewer.pal(12,"Paired")生成的颜色调色板

library(wordcloud2)
wordcloud2(wf)
wordcloud2(wf,size=0.5)#词汇大小0.5
wordcloud2(wf,size=0.5,color="random-light",backgroundColor="black")#词汇的颜色为随机的浅色，背景颜色为黑色
wordcloud2(wf,shape="star",size=0.5)#词汇的形状为星形
wordcloud2(wf,figPath="love.png",color="skyblue",backgroundColor="black")#并将生成的词云图像保存到名为"cat"的文件中
#wordcloud2(wf,figPath="cat.png",color="skyblue",backgroundColor="black")

letterCloud(wf,word="R",color="random-light",backgroundColor="black")#创建词云，词云形状R
letterCloud(wf,word="SDA",color="random-light",backgroundColor="black")



###########################
library(textstem)
docs3<-stem_strings(docs)[1]
a<-unlist(str_split(docs3,"[,]"))
docs4<-lemmatize_strings(docs)[1]
b<-unlist(str_split(docs4,"[,]"))