#STQD6114 Project_1 PANZHANGYU P136922
library(tm)
library(dplyr)
library(topicmodels)
library(tidytext)
library(ggplot2)
library(tidyr)

mytext <- DirSource("D:/学校/出国/课程/STQD6114/Project2/Natural_disasters_news")
docs <- VCorpus(mytext)
docs <- tm_map(docs, content_transformer(tolower))
docs <- tm_map(docs, removePunctuation)
docs <- tm_map(docs, removeNumbers)
docs <- tm_map(docs, removeWords, stopwords("english"))
docs <- tm_map(docs, removeWords, c("said", "will", "can", "must", "also"))
docs <- tm_map(docs, stripWhitespace)

#
dtm <- DocumentTermMatrix(docs)
dtm


##### Task_1

set.seed(1234)
# LDA
lda_model <- LDA(dtm, k = 4, control = list(seed = 1234))
lda_model

# 提取主题词项概率 Extracting subject term probability
topic_terms <- tidy(lda_model, matrix = "beta")

# 找出每个主题中最常见的八个词项 Find the eight most common terms in each topic
top_terms <- topic_terms %>%
  group_by(topic) %>%
  slice_max(beta, n = 8) %>%
  ungroup() %>%
  arrange(topic, -beta)

# 可视化每个主题中最常见的词项 Visualize the most common terms in each topic
# 1.png
top_terms %>%
  mutate(term = reorder_within(term, beta, topic)) %>%
  ggplot(aes(beta, term, fill = factor(topic))) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~ topic, scales = "free") +
  scale_y_reordered() +
  labs(title = "Top Terms in Each Topic", x = "Beta", y = "Term")

# 计算beta差异 Calculating beta differences
beta_spread <- topic_terms %>%
  mutate(topic = paste0("topic", topic)) %>%
  pivot_wider(names_from = topic, values_from = beta) %>%
  filter(topic1 > .001 | topic2 > .001) %>%
  mutate(log_ratio = log2(topic2 / topic1))

beta_spread
#>> beta_spread
#> A tibble: 370 × 6
#>term            topic1    topic2    topic3    topic4 log_ratio
#><chr>            <dbl>     <dbl>     <dbl>     <dbl>     <dbl>
#>  1 access        0.000812 1.89e-  3 6.84e-  4 5.32e-  4     1.22 
#>2 according     0.00108  2.21e-  3 1.37e-  3 1.95e-  3     1.03 
#>3 across        0.000627 1.26e-  3 1.52e-  3 1.24e-  3     1.01 
#>4 activities    0.00189  6.31e-  4 6.84e-  4 1.10e-  8    -1.59 
#>5 adapt         0.00108  2.78e-204 4.56e-  4 1.08e-209  -666.   
#>6 added         0.00135  2.21e-  3 1.17e-  3 1.39e-  3     0.707
#>7 address       0.000754 1.26e-  3 6.84e-  4 3.81e-  5     0.744
#>8 addressing    0.00107  3.16e-  4 2.28e-  4 6.64e-  6    -1.76 
#>9 advancements  0.00108  9.56e-205 1.18e-  6 1.76e-  4  -668.   
#>10 advertisement 0.00108  3.16e-209 1.04e-206 3.61e-213  -683.   
#> ℹ 360 more rows
#> ℹ Use `print(n = ...)` to see more rows

# 提取每个文档的主题概率 Extract topic probabilities for each document
document_topics <- tidy(lda_model, matrix = "gamma")

document_topics
#>> document_topics
#> A tibble: 200 × 3
#>document topic     gamma
#><chr>    <int>     <dbl>
#>  1 1.txt        1 0.0000333
#>2 10.txt       1 0.0000350
#>3 11.txt       1 0.0000472
#>4 12.txt       1 0.0000552
#>5 13.txt       1 0.0000346
#>6 14.txt       1 1.00     
#>7 15.txt       1 1.00     
#>8 16.txt       1 0.0000333
#>9 17.txt       1 0.0000547
#>10 18.txt       1 1.00     
#> ℹ 190 more rows
#> ℹ Use `print(n = ...)` to see more rows







##### Task_2

# 选择聚类算法：k-means
# 执行 k-means 聚类
set.seed(123)
k <- 3 
kmeans_result <- kmeans(dtm, centers = k)
# 将聚类结果添加到文档数据中 Add clustering results to document data
cluster_assignments <- data.frame(document = rownames(dtm), cluster = kmeans_result$cluster)
# 可视化聚类结果 Visualizing clustering results
# 2.png
cluster_plot <- ggplot(cluster_assignments, aes(x = factor(cluster))) +
  geom_bar(fill = "skyblue", width = 0.5) +
  labs(title = "Cluster Distribution", x = "Cluster", y = "Frequency") +
  theme_minimal()
# 显示聚类结果的分布图 Display the distribution graph of clustering results
# 3.png
print(cluster_plot)
#这种情况下，x=1的条形远超过2和3可能表明在 k-means 聚类中，
#In this case, the fact that the number of bars with x=1 far exceeds that of bars 2 and 3 may indicate that in the k-means clustering,
#有一个聚类包含了大多数的文档，而其他的聚类相对较少。
#There is one cluster that contains most of the documents, while the other clusters have relatively few.

summary(kmeans_result)



# 使用层次聚类算法构建聚类: hierarchical clustering
hierarchical_result <- hclust(dist(dtm), method = "ward.D2")
# 将树形结构剪枝以得到指定数量的聚类 Prune the tree to get a specified number of clusters
num_clusters <- 3
hierarchical_clusters <- cutree(hierarchical_result, num_clusters)
# 统计每个聚类的大小 Count the size of each cluster
table(hierarchical_clusters)
#有47个文档被归类到了第一个聚类中，2个文档被归类到了第二个聚类中，
#There are 47 documents classified into the first cluster and 2 documents classified into the second cluster.
#而只有1个文档被归类到了第三个聚类中
#And only 1 document was classified into the third cluster
# 可视化聚类结果 Visualizing clustering results
plot(hierarchical_result, hang = -1, labels = hierarchical_clusters)



# HDBScan (Hierarchical Density-Based Spatial Clustering of Applications with Noise)
library(dbscan)
library(fpc) 
dist.matrix <- dist(dtm)
# DBSCAN 
dbscan_result <- dbscan(dist.matrix, eps = 0.1, MinPts = 5)
# 查看聚类结果 View clustering results
table(dbscan_result$cluster)
#The HDBScan algorithm does not assign data points outside any cluster, 
#but treats them as noise points.
#This result may have many reasons: 
#inappropriate parameter settings, insufficient data features, small data size
# 生成散点图 Generate a scatter plot
# 4.png
plot(dist.matrix, col = dbscan_result$cluster + 1L)



##### Task_3
library(tm)
library(SnowballC)
library(wordcloud)
library(RColorBrewer)
library(syuzhet)
library(ggplot2)
library(dplyr)

reviews_data <- read.csv("reviews_data.csv", stringsAsFactors = FALSE, encoding = "UTF-8")

# 只选择包含评论的列 Select only columns containing comments
reviews <- reviews_data$Review

#
docs <- Corpus(VectorSource(reviews))
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

# 构建词频矩阵 Constructing a word frequency matrix
dtm <- TermDocumentMatrix(docs)
dtm_m <- as.matrix(dtm)
dtm_v <- sort(rowSums(dtm_m), decreasing = TRUE)
dtm_d <- data.frame(word = names(dtm_v), freq = dtm_v)

# 展示最常见的5个词语 Show the top 5 most common words
head(dtm_d, 5)

# 绘制柱状图 Draw a bar chart
# 5.png
barplot(dtm_d[1:5,]$freq, las = 2, names.arg = dtm_d[1:5,]$word,
        col ="lightgreen", main ="Top 5 most frequent words",
        ylab = "Word frequencies")

# 生成词云 Generate word cloud
# 6.png
set.seed(1234)
wordcloud(words = dtm_d$word, freq = dtm_d$freq, min.freq = 5,
          max.words = 100, random.order = FALSE, rot.per = 0.40, 
          colors = brewer.pal(8, "Dark2"))

# 计算情感得分 Calculating sentiment scores
syuzhet_vector <- get_sentiment(reviews, method = "syuzhet")
bing_vector <- get_sentiment(reviews, method = "bing")
afinn_vector <- get_sentiment(reviews, method = "afinn")
nrc_vector <- get_sentiment(reviews, method = "nrc")

head(syuzhet_vector, 10)
head(bing_vector, 10)
head(afinn_vector, 10)
head(nrc_vector, 10)

# 比较不同情感得分方法 Comparing different sentiment scoring methods
comparison <- rbind(
  sign(head(syuzhet_vector)),
  sign(head(bing_vector)),
  sign(head(afinn_vector))
)
print(comparison)

# NRC情感分类
nrc_sentiment <- get_nrc_sentiment(reviews)

head(nrc_sentiment, 10)

# 情感分类的可视化 Visualization of sentiment classification
td <- data.frame(t(nrc_sentiment))
td_new <- data.frame(rowSums(td))
names(td_new)[1] <- "count"
td_new <- cbind("sentiment" = rownames(td_new), td_new)
rownames(td_new) <- NULL
td_new2 <- td_new[1:8,]

# 绘制柱状图 Draw a bar chart
# 7.png
quickplot(sentiment, data = td_new2, weight = count, geom = "bar", fill = sentiment, ylab = "count") + ggtitle("Survey sentiments")

# 绘制情感百分比 Plotting sentiment percentages
# 8.png
barplot(
  sort(colSums(prop.table(nrc_sentiment[, 1:8]))), 
  horiz = TRUE, 
  cex.names = 0.7, 
  las = 1, 
  main = "Emotions in Text", xlab = "Percentage"
)

