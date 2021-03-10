library(tidyverse)

scores_df <- read.csv("data:/scoresspread.csv")

summarytable <- scores_df %>%
  filter(team_favorite == team_home) %>%
  group_by(team_favorite) %>%
  summarise(average_homescore = mean(score_home)) %>% 
  rename("Team" = "team_favorite", "Score" = "average_homescore")

kable(summarytable)