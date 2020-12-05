all: en_US.twitter.txt

en_US.twitter.txt:
	kaggle datasets download "crmercado/tweets-blogs-news-swiftkey-dataset-4million" -f "final/en_US/en_US.twitter.txt"
	unzip en_US.twitter.txt.zip
	rm en_US.twitter.txt.zip
clean:
	rm en_US.twitter.txt
