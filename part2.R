# Web scrapping  网络抓取
eg6<-readLines("https://en.wikipedia.org/wiki/Data_science") 
#从网址"https://en.wikipedia.org/wiki/Data_science"读取所有行
eg6[grep("\\h2",eg6)]#二级标题
eg6[grep("\\p",eg6)]#段落 #paragraph#这两行代码分别查找eg6中包含<h2>标签和<p>标签的行
#Using library XML
library(XML)

doc<-htmlParse(eg6)#解析为HTML文档
doc.text<-unlist(xpathApply(doc,'//p',xmlValue)) #提取doc中所有<p>标签和<h2>标签的文本内容。
unlist(xpathApply(doc,'//h2',xmlValue))
#Using library httr
library(httr)
eg7<- GET("https://www.edureka.co/blog/what-is-data-science/")#同上，创建了EG7
doc<-htmlParse(eg7)
doc.text<-unlist(xpathApply(doc,'//p',xmlValue))

#Using library rvest
library(rvest) #rvest是一个用于网络抓取的R包。
eg8<-read_html("https://www.edureka.co/blog/what-is-data-science/")#读取HTML文档
nodes<-html_nodes(eg8,'.color-4a div span , .btn-become-profesional-link+ p')#用谷歌提取CSS
texts<-html_text(nodes)#提取nodes中的HTML节点的文本内容

#Selecting multiple pages
pages<-paste0('https://www.amazon.co.jp/s?k=skincare&crid=28HIW1TYLV9UM&sprefix=skincare%2Caps%2C268&ref=nb_sb_noss_1&page=',0:9)
#生成了包含10个网址的向量
eg10<-read_html(pages[1])
#从第一个网址读取HTML文档
nodes<-html_nodes(eg10,'.a-price-whole')
#从eg10中提取类名为a-price-whole 的文本内容，这个节点通常表示价格
texts<-html_text(nodes)
Price<-function(page){
  url<-read_html(page) 
  nodes<-html_nodes(url ,'.a-price-whole ') 
  html_text(nodes)
}
#定义了一个函数Price，该函数接受一个网址作为参数，从该网址读取HTML文档，
#提取类名为a-price-whole的HTML节点的文本内容，并返回这些文本内容。

sapply(pages,Price)
#对pages中的每一页应用这一函数

do.call("c",lapply(pages,Price))
#对pages中的每个网址应用Price函数，然后将所有结果合并为一个向量。






