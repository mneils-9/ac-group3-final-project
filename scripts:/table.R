library(tidyverse)

source("changedf.R")

summarytable <- scores_df %>%
  filter(team_favorite == team_home) %>%
  group_by(team_favorite) %>%
  summarise(average_homescore = mean(score_home))

kable(summarytable)