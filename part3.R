#Part 3: Twitter API
#Using library rvest
library(rtweet) #用于获取Twitter数据的R包
#The following please fill in your info
twitter_token<-create_token( 
  app=appname, 
  consumer_key=key, 
  consumer_secret=secret, 
  access_token=access_token, 
  access_secret=access_secret)
#行代码创建了一个Twitter令牌，
#用于身份验证。你需要填写你的应用名称、消费者密钥、
#消费者秘密、访问令牌和访问秘密。

#Search 500 tweets using #covid
rstats_tweets<-search_tweets(q="#covid",n=500,lang="en")
#搜索包含#covid标签的500条英文推文，
#并将结果保存在rstats_tweets中。

users<-search_users(q="#covid",n=500)
#搜索包含#covid标签的500个用户，并将结果保存在users中。

#Twitter's STREAM API
streamtime=60
filefilename<-"rtry.json" # backup 
#设置了流式推文的超时时间（60秒）和文件名（“rtry.json”）
rstats_tweets<-stream_tweets(q="#covid",timeout=streamtime,file_name=filename,parse=F) #stream tweets
#这行代码开始流式获取包含#covid标签的推文，超时时间为streamtime，结果保存在文件filename中。
rtweet<-parse_stream(filename)
#这行代码解析流式获取的推文数据，并将结果保存在rtweet中。
users_data(rtweet)
#这行代码获取rtweet中的用户数据。