# P136922 Pan Zhangyu

# 读取歌词文件
song1 <- read.csv("song1.csv", header = TRUE, stringsAsFactors = FALSE)
song2 <- read.csv("song2.csv", header = TRUE, stringsAsFactors = FALSE)
song3 <- read.csv("song3.csv", header = TRUE, stringsAsFactors = FALSE)
# 显示歌词内容
print(song1)

print(song2)

print(song3)

# 加载所需的库
library(tm)
library(SnowballC)

# 定义数据清洗和预处理函数
clean_and_preprocess <- function(text) {
  text <- gsub("[[:punct:]]", "", text)
  text <- tolower(text)
  text <- removeWords(text, stopwords("english"))
  text <- stripWhitespace(text)
  return(text)
}

# 对每首歌曲的歌词进行数据清洗和预处理
song1_clean <- clean_and_preprocess(song1)
song2_clean <- clean_and_preprocess(song2)
song3_clean <- clean_and_preprocess(song3)

# 显示预处理后的歌词
print(song1_clean)

print(song2_clean)

print(song3_clean)

# 加载所需的库
library(tm)

# 创建语料库对象
corpus <- Corpus(VectorSource(c(song1_clean, song2_clean, song3_clean)))

# 创建文档-词项矩阵
dtm <- DocumentTermMatrix(corpus)

# 计算词频
freq <- colSums(as.matrix(dtm))

# 按词频降序排列
freq_sorted <- sort(freq, decreasing = TRUE)

# 输出频率最高的五个词汇及其对应的频率
top_terms <- head(freq_sorted, 5)
print(top_terms)

# 加载所需的库
library(wordcloud)

# 创建词云
wordcloud(names(top_terms), freq = top_terms, scale = c(4, 0.5), min.freq = 1, random.order = FALSE, colors = brewer.pal(8, "Dark2"))
