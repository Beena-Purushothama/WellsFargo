## Loading the packages
library(tidyverse)
library(rvest)
library(stringr)

setwd("C:/UmeshJN/Personal/Learning/DataPipeline/WebScraping/WellsFargo-ConsumerAffairs/")

## Creating the list of pages where we can fetch the review comments 
list_of_pages <- "https://www.consumeraffairs.com/finance/wells_fargo.html"
list_of_pages <- c(list_of_pages, str_c(url, '?start=', seq(2,87,1)))


## Function to fetch the customer names 
getCustomerNames <- function(url) {
   read_html(url) %>% 
    html_nodes('.rvw-aut__inf-nm') %>% 
    html_text() %>% 
    str_trim() %>% 
    unlist()
}

## Function to fetch the dates 
getDates <- function(url){
  
  dates <- read_html(url) %>% 
  html_nodes('.ca-txt-cpt') %>% 
  html_text() %>% 
  str_trim() %>% 
  unlist() 
  
  dates[-1] %>% 
    str_replace("Original review: ", "") %>%
    str_trim()
}

## Function to fetch the review comments
getComments <- function(url) {
  read_html(url) %>% 
  html_nodes('.rvw-bd') %>% 
  html_text() %>% 
  str_replace("/View more/.*", "") %>%
  str_trim() %>% 
  unlist()
}

## Function to fetch the rating
getRating <- function(url) {
  read_html(url) %>% 
    html_nodes('.rvw__hdr-stat img') %>%
    html_attr("src") %>%
    str_replace("//media.consumeraffairs.com/static/img/icons/stars/stars-", "") %>%
    str_replace("\\..*", "")
}


## Function to fetch the data and bind them into a tibble
get_data <- function(url){
  
  ## Getting the required data values
  customerName <- getCustomerNames(url)
  dates <- getDates(url)
  content <- getComments(url)
  ratings <- getRating(url)
    
  # Combine into a tibble
  combined_data <- tibble(CustomerName = customerName,
                         Date = dates,
                         ReviewComment = content,
                         Ratings = ratings)
 
  combined_data 
}

scrape_all_review_comments <- function(list_of_pages){
  # Apply the extraction and bind the individual results back into one table, 
  # which is then written as a tsv file into the working directory
  list_of_pages %>% 
    # Apply to all URLs
    map(get_data) %>%  
    # Combine the tibbles into one tibble
    bind_rows() %>%                           
    # Write a tab-separated file
    write_tsv('WellsFargo_ConsumerAffairs_Review_Comments.tsv')
}


View(scrape_all_review_comments(list_of_pages))

