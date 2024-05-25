# P1T2 6114 Pan Zhangyu P136922
#Selecting multiple pages
#selector gadget
library(XML)
library(httr)
library(rvest)

############################### Choose of it ##########################################
#Task2 Q1 Select two different products with the same categories

#PVC cartoon (aa)
pages<-paste0('https://www.amazon.com/s?k=pvc+cartoon&rh=n%3A165793011%2Cn%3A2514571011&dc&language=zh&ds=v1%3ALXB7xVounPQyG22LW1JUhTOm4LDC8TjW2OhTmmbrYwY&crid=3LEMBSV4Z2E2B&qid=1714217752&rnid=2941120011&sprefix=PVC+catto%2Caps%2C521&ref=sr_nr_n_2',0:2)
aa<-read_html(pages[1])
#Garage kit (ab)
pages<-paste0('https://www.amazon.com/s?k=%E6%89%8B%E5%8A%9E%E5%8A%A8%E6%BC%AB%E6%A8%A1%E5%9E%8B&crid=2XCV5F9555BQH&sprefix=%E6%89%8B%E5%8A%9E%2Caps%2C1012&ref=nb_sb_ss_ts-doa-p_2_2',0:2)
ab<-read_html(pages[1])
aa<-ab

##########################################

#Currency Unit
unit<-html_nodes(aa,'.a-price-symbol')
#price
p<-html_nodes(aa,'.a-price-whole')
#score
score<-html_nodes(aa,'.aok-align-bottom')
#product name
name<-html_nodes(aa,'.s-line-clamp-4')

######################### 
texts<-html_text(unit)
texts<-html_text(p)
texts<-html_text(score)
texts<-html_text(name)
#########################

#unit
Unit<-function(page){ 
  url<-read_html(page) 
  nodes<-html_nodes(url ,'.a-price-symbol') 
  html_text(nodes)}
sapply(pages,Unit)
do.call("c",lapply(pages,Unit))

#price
Price<-function(page){ 
  url<-read_html(page) 
  nodes<-html_nodes(url ,'.a-price-whole') 
  html_text(nodes)}
sapply(pages,Price)
do.call("c",lapply(pages,Price))

#score
Score<-function(page){ 
  url<-read_html(page) 
  nodes<-html_nodes(url ,'.aok-align-bottom') 
  html_text(nodes)}
sapply(pages,Score)
do.call("c",lapply(pages,Score))

#name
Name<-function(page){ 
  url<-read_html(page) 
  nodes<-html_nodes(url ,'.s-line-clamp-4') 
  html_text(nodes)}
sapply(pages,Name)
do.call("c",lapply(pages,Name))

############################### Choose of it ##########################################
#Task2 Q2 Movies of two different genres

#Cartoon theater version (ba)
pages<-paste0('https://bangumi.tv/anime/tag/%E5%89%A7%E5%9C%BA%E7%89%88',0:2)
ba<-read_html(pages[1])
aa<-ba
#Cartoon TV (bb)
pages<-paste0('https://bangumi.tv/anime/tag/TV/?sort=rank',0:2)
bb<-read_html(pages[1])
aa<-bb
###########################################
#Number of raters
r<-html_nodes(aa,'.tip_j')
#star
star<-html_nodes(aa,'.starstop-s')
#score
score<-html_nodes(aa,'.fade')
#name
name<-html_nodes(aa,'.grey')

######################### 
texts<-html_text(r)
texts<-html_text(star)
texts<-html_text(score)
texts<-html_text(name)
#########################

#Number of raters
R<-function(page){ 
  url<-read_html(page) 
  nodes<-html_nodes(url ,'.tip_j') 
  html_text(nodes)}
sapply(pages,R)
do.call("c",lapply(pages,R))

#star
Star<-function(page){ 
  url<-read_html(page) 
  nodes<-html_nodes(url ,'.starstop-s') 
  html_text(nodes)}
sapply(pages,Star)
do.call("c",lapply(pages,Star))

#score
Score<-function(page){ 
  url<-read_html(page) 
  nodes<-html_nodes(url ,'.fade') 
  html_text(nodes)}
sapply(pages,Score)
do.call("c",lapply(pages,Score))

#name
Name<-function(page){ 
  url<-read_html(page) 
  nodes<-html_nodes(url ,'.grey') 
  html_text(nodes)}
sapply(pages,Name)
do.call("c",lapply(pages,Name))

############################### Choose of it ##########################################
#Task2 Q3 Songs from two different artists

#Mili (ca)
pages<-paste0('https://music.163.com/#/artist?id=339594',0:2)
ca<-read_html(pages[1])
aa<-ca
#Rim (cb)
pages<-paste0('https://music.youtube.com/channel/UCJI8ldaIM5VGPh_4SkoSRoA',0:2)
cb<-read_html(pages[1])
aa<-cb
###########################################
#Number of raters
r<-html_nodes(aa,'.tip_j')
#star
star<-html_nodes(aa,'.starstop-s')
#score
score<-html_nodes(aa,'.fade')
#name
name<-html_nodes(aa,'.grey')

######################### 
texts<-html_text(r)
texts<-html_text(star)
texts<-html_text(score)
texts<-html_text(name)
#########################

############################### Choose of it ##########################################
#Task2 Q4 Providers of two different services/industries

#hotel (da)
pages<-paste0('https://www.klook.com/zh-CN/hotels/searchresult/?spm=Home.CategoryBar_L2_LIST&clickId=731ee52575&check_in=2024-05-01&check_out=2024-05-04&room_num=1&adult_num=1&child_num=0&age=&k_lang=zh_CN&k_currency=EUR&stype=city&svalue=6&override=%E6%96%B0%E5%8A%A0%E5%9D%A1,%20%E6%96%B0%E5%8A%A0%E5%9D%A1&title=%E6%96%B0%E5%8A%A0%E5%9D%A1&city_id=6&latlng=1.352083,103.819837',0:2)
da<-read_html(pages[1])
aa<-da
#Attraction tickets (db)
pages<-paste0('https://www.klook.com/zh-CN/attractions/singapore/c6/?spm=Attraction_Vertical.ChangeDestination.Destination&clickId=0a527f081b',0:2)
db<-read_html(pages[1])
aa<-db
###########################################
#evaluate
evaluate<-html_nodes(aa,'.hotel-review-desc')
#price
p<-html_nodes(aa,'.price-amount')
#score
score<-html_nodes(aa,'.hotel-review-score')
#product name
name<-html_nodes(aa,'.prefix')

######################### 
texts<-html_text(unit)
texts<-html_text(p)
texts<-html_text(score)
texts<-html_text(name)
#########################

#evaluate
Evaluate<-function(page){ 
  url<-read_html(page) 
  nodes<-html_nodes(url ,'.hotel-review-desc') 
  html_text(nodes)}
sapply(pages,Unit)
do.call("c",lapply(pages,Unit))

#price
Price<-function(page){ 
  url<-read_html(page) 
  nodes<-html_nodes(url ,'.price-amount') 
  html_text(nodes)}
sapply(pages,Price)
do.call("c",lapply(pages,Price))

#score
Score<-function(page){ 
  url<-read_html(page) 
  nodes<-html_nodes(url ,'.hotel-review-score') 
  html_text(nodes)}
sapply(pages,Score)
do.call("c",lapply(pages,Score))

#name
Name<-function(page){ 
  url<-read_html(page) 
  nodes<-html_nodes(url ,'.prefix') 
  html_text(nodes)}
sapply(pages,Name)
do.call("c",lapply(pages,Name))