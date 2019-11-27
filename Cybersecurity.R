# I will use anomalize package in order to detect anomalies within the time series,
# also use tidyverse package for processing and coindeskr to get bitcoin data
library(anomalize)
library(tidyverse)
library(coindeskr)

#Get bitcoin data from 1st January 2017
bitcoin_data <- get_historic_price(start = "2017-01-01")

#Convert bitcoin data to a time series
bitcoin_data_ts = bitcoin_data %>% rownames_to_column() %>% as.tibble() %>% mutate(date = as.Date(rowname)) %>% select(-one_of('rowname'))

#Decompose data using time_decompose() function in anomalize package. We will use stl method which extracts seasonality

bitcoin_data_ts %>% time_decompose(Price, method = "stl", frequency = "auto", trend = "auto") %>%  anomalize(remainder, method = "gesd", alpha = 0.05, max_anoms = 0.1) %>% plot_anomaly_decomposition()

#Plot the data again by recomposing data

bitcoin_data_ts %>% time_decompose(Price) %>% anomalize(remainder) %>% time_recompose() %>%  plot_anomalies(time_recomposed = TRUE, ncol = 3, alpha_dots = 0.5)

#Extract the anomalies
anomalies=bitcoin_data_ts %>% time_decompose(Price) %>%  anomalize(remainder) %>%  time_recompose() %>%  filter(anomaly == 'Yes')