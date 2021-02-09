library(tidyverse)

# Read in data.
scores_df <- read.csv("data:/spreadspoke_scores.csv")

# Add a new column to the dataframe where it tells us if the home team won/lost.
scores_df <- scores_df %>% mutate(home_win = (score_home > score_away))

# Proportion of home teams that won in each season. 
prop_home_win <- scores_df %>% 
  group_by(schedule_season) %>% 
  filter(home_win == TRUE, .preserve = TRUE) %>% 
  summarise(prop = n()) %>%
  mutate(prop_home_wins = prop / sum(prop))

# Create a dataframe with rows containing spread data.
spread_scores_df <- scores_df %>% filter(!is.na(spread_favorite))

# Average spread of each season.
avg_spreads <- spread_scores_df %>% 
  group_by(schedule_season) %>% 
  summarize(avg_spread = mean(spread_favorite))

avg_ous <- spread_scores_df %>% 
  group_by(schedule_season) %>% 
  summarise(avg_ou = mean(over_under_line))

year_score_df <- left_join(prop_home_win, avg_spreads)

year_score_df <- left_join(year_score_df, avg_ous)

sb_spreads <- spread_scores_df %>% 
  filter(schedule_week == "Superbowl") 

ggplot(data = sb_spreads) +
  geom_line(mapping = aes(x = schedule_season, y = spread_favorite))

ggplot() +
  geom_line(data = year_score_df, aes(x = schedule_season, y = prop), color = "darkcyan") +
  ggsave("homewins.png")

ggplot() +
  geom_line(data = year_score_df, aes(x = schedule_season, y = ou_line, color = "darkcyan"))

            