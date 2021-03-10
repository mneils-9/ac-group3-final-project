library(tidyverse)

source("changedf.R")

table <- scores_df %>% filter(favorite_cover == TRUE) %>%
  filter(schedule_season  >= 2020) %>% 
  group_by(team_favorite) %>% 
  summarize(count = n()) %>%
  arrange(count)

kable(table)
