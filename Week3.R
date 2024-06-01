eg6<-readLines("https://en.wikipedia.org/wiki/Data_science")
eg6[grep("\\h2",eg6)]
eg6[grep("\\p",eg6)] #paragraph

#Using library XML
install.packages("XML")
library(XML)
doc<-htmlParse(eg6)
doc.text<-unlist(xpathApply(doc,'//p',xmlValue))
unlist(xpathApply(doc,'//h2',xmlValue))

#Using library httr
install.packages("httr")
library(httr)
eg7<-GET("https://www.edureka.co/blog/what-is-data-science/")
doc<-htmlParse(eg7)
doc.text<-unlist(xpathApply(doc,'//p',xmlValue))
doc.text

#Using library rvest
#install.packages("rvest")
library(rvest)
eg8<-read_html("https://en.wikipedia.org/wiki/Data_science")
nodes<-html_nodes(eg8,'p , a')
texts<-html_text(nodes)
texts

#Selecting multiple pages
#网址加上&，页数0是第一页
pages<-paste0('https://www.amazon.com/s?k=%E6%89%8B%E5%8A%9E&page=',0:6)
eg10<-read_html(pages[1])
#用selector gadget插件看价格星级之类的，复制下框的标
nodes<-html_nodes(eg10,'.aok-align-bottom , .a-price-whole')
texts<-html_text(nodes)
texts

Price<-function(page){ 
  url<-read_html(page) 
  nodes<-html_nodes(url ,'.a-price-whole ') 
  html_text(nodes)}
sapply(pages,Price)
do.call("c",lapply(pages,Price))


#Regular expression - a languange to identify pattern/sequence of character

##grep functions (without use any package)
ww<-c("statistics","estate","castrate","catalyst","Statistics")
ss<-c("I like statistics","I like bananas","Estates and statues are expensive")

#1st function - grep() -give the location of pattern
grep(pattern="stat",x=ww) #x is the document, will return the location only
grep(pattern="stat",x=ww,ignore.case=T) #ignore the capital/small letter, will return the location only
grep(pattern="stat",x=ww,ignore.case=T,value=T) #ignore the capital/small letter, return to that particular words

#2nd function - grepl() - give logical expression
grepl(pattern="stat",x=ww) #Return true/false
grepl(pattern="stat",x=ss)

#3rd function - regexpr()
#return a vector of two attributes; position of the first match and its length
#if not, it returns -1
regexpr(pattern="stat",ww)
regexpr(pattern="stat",ss)

#4th function - gregexpr()
gregexpr(pattern="stat",ss)

#5th function - regexec()
regexec(pattern="(st)(at)",ww)

#6th function - sub()
sub("stat","STAT",ww,ignore.case=T)
sub("stat","STAT",ss,ignore.case=T)

#7th function - gsub()
gsub("stat","STAT",ss,ignore.case=T)
