library(tidyverse)

scores_df <- read.csv("spreadspoke_scores.csv")

scores_df <- scores_df %>% mutate(home_win = (score_home > score_away))

prop_home_win <- scores_df %>% 
  group_by(schedule_season) %>% 
  filter(home_win == TRUE, .preserve = TRUE) %>% 
  summarise(prop = n()) %>%
  mutate(prop_home_wins = prop / sum(prop))

spread_scores_df <- scores_df %>% filter(!is.na(spread_favorite))

avg_spreads <- spread_scores_df %>% 
  group_by(schedule_season) %>% 
  summarize(avg_spread = mean(spread_favorite))

year_score_df <- left_join(prop_home_win, avg_spreads)

sb_spreads <- spread_scores_df %>% 
  filter(schedule_week == "Superbowl") 

ggplot(data = sb_spreads) +
  geom_line(mapping = aes(x = schedule_season, y = spread_favorite))

ggplot() +
  geom_line(data = year_score_df, aes(x = schedule_season, y = prop), color = "darkcyan") +
  ggsave("homewins.png")
