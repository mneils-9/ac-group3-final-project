library(tidyverse)

team_anno <- read.csv("data:/teamanno.csv")
scores_df <- read.csv("data:/spreadspoke_scores.csv")

scores_df <- scores_df %>% mutate(home_win = (score_home > score_away))
scores_df <- scores_df %>% filter(!is.na(spread_favorite))

scores_df <- mutate(scores_df, team_favorite = NA)
for (i in 1:nrow(scores_df)) {
  if (scores_df$team_favorite_id[i] == "PICK") {
    scores_df$team_favorite[i] <- "PICK"
  } else {
    team <- teams %>% 
      filter(Abbreviation == scores_df$team_favorite_id[i]) %>% 
      select(Name)
    scores_df$team_favorite[i] <- team
  }
}

# Team won for each game.
scores_df <- mutate(scores_df, team_win = NA)
for (i in 1:nrow(scores_df)) {
  if (scores_df$home_win[i]) {
    scores_df$team_win[i] <- scores_df$team_home[i]
  } else {
    scores_df$team_win[i] <- scores_df$team_away[i]
  }
} 

summary_info <- list()
summary_info$num_obs <- scores_df %>% 
  filter(!is.na(spread_favorite)) %>% 
  nrow()
summary_info$num_unique_years <- length(unique(scores_df$schedule_season))
summary_info$num_different_teams <- length(unique(scores_df$team_home))
summary_info$favorite_min_spread <- scores_df %>% 
  filter(spread_favorite == max(spread_favorite)) %>% 
  pull(spread_favorite) %>% 
  nth(1)
summary_info$favorite_max_spread <- scores_df %>% 
  filter(spread_favorite == min(spread_favorite)) %>% 
  pull(spread_favorite)
summary_info$favorite_spread_mean <- mean(scores_df$spread_favorite, na.rm = T)
summary_info$prop_home_wins <- scores_df %>% 
  filter(score_home > score_away) %>% 
  summarize(prop = n() / nrow(scores_df)) %>% 
  pull(prop)
summary_info$temp_mean <- mean(scores_df$weather_temperature, na.rm = T)
summary_info$prop_home_favorite <- scores_df %>% filter(team_home == team_win) %>% 
  summarize(prop = n() / nrow(scores_df)) %>% 
  pull(prop)