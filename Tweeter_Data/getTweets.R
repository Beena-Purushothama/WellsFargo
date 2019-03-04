## load packages
library(rtweet)
library(tidyverse)
library(ggthemes)
library(viridis)

## Creating the token for connecting to the tweeter API for fetching the data
create_token(
  app = "my_twitter_research_app",
  consumer_key = "add your consumer key",
  consumer_secret = "add your consumer secret",
  access_token = "add your token",
  access_secret = "add your access secret")


#################################################
###### Tweets mentioning Ask_WellsFargo #########
#################################################

## Fetching 10000 tweets mentioning "Ask_WellsFargo"
askWellsFargo <- search_tweets(q = "Ask_WellsFargo", n = 10000, include_rts = FALSE, lang = 'en')

## plot time series of tweets
ts_plot(askWellsFargo, "1 hours") +
  theme_economist() +
  theme(plot.title = ggplot2::element_text(face = "bold")) +
  labs(
    x = NULL, y = NULL,
    title = "Frequency of tweets mentioning 'Ask_WellsFargo' from past 9 days",
    subtitle = "Twitter status (tweet) counts aggregated using one-hour intervals",
    caption = "\nSource: Data collected from Twitter's REST API via rtweet"
  )


## Writing into csv file
write_as_csv(askWellsFargo, "Ask_WellsFargo_Tweets.csv", prepend_ids = TRUE, na = "", fileEncoding = "UTF-8")

#################################################
############# Followers count for banks #########
#################################################

## getting followings count
banks <- c("Chase", "Wellsfargo", "GoldmanSachs", "MorganStanley", "CapitalOne", "BankOfAmerica", "Citi")
followers <- lookup_users(banks) %>% select(followers_count)

## Building tibble
following <- tibble(BankNames = banks,
                    Followers = followers$followers_count)


## PLotting the data
ggplot(following, aes(x = BankNames, y = Followers, fill = BankNames)) +
  geom_bar(stat = "identity") +
  scale_fill_viridis_d()  +
  theme_economist() +
  labs(title = "Tweeter Followers of Top Financial Firms") +
  theme(legend.position = "none")
