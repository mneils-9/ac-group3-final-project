library(tidyverse)

data <- spreadspoke_scores

data <- data %>% mutate(home_win = (score_home > score_away))

home_wins_season <- data %>% 
  group_by(schedule_season) %>% 
  filter(home_win == TRUE, .preserve = TRUE) %>% 
  summarise(prop = n()) %>%
  mutate(prop = prop / sum(prop))
