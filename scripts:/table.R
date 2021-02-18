library(tidyverse)
source("changedf.R")
scores_df %>% group_by(schedule_week) %>% summarise(average_homescore=mean(score_home))
