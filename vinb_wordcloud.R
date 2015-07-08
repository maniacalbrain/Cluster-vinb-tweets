library(tm)
library(wordcloud)

tweets = read.csv("vinb2.txt", stringsAsFactors = FALSE, sep='\t', header=TRUE)

#removes some ascii characters that showed up
tweets_text = tweets$Text
tweets_text = iconv(tweets_text, "latin1", "ASCII", sub="")


corpus = Corpus(VectorSource(tweets_text))

corpus = tm_map(corpus, tolower)
corpus=tm_map(corpus, PlainTextDocument) #this either needs to be done or is the reason the above mentioned ascii doesn't get remove...

corpus = tm_map(corpus, removePunctuation)
corpus = tm_map(corpus, removeWords, c(stopwords("english"), "vinb", "peoplesdebate", "amp")) #removes stopwords, common words and amp, left over from &amp;
frequencies = DocumentTermMatrix(corpus)
allTweets = as.data.frame(as.matrix(frequencies))

words <-colnames(allTweets)
freq = colSums(allTweets)

png("wordcloud.png", width=7,height=7, units="in", res=300)
wordcloud(words, freq, max.words = 250, scale=c(2, 0.5), colors = brewer.pal(8,"Dark2"))
dev.off()
