library(tidyverse)

source("changedf.R")

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
summary_info$prop_home_wins <- mean(scores_df$team_home > scores_df$team_away)
summary_info$temp_mean <- mean(scores_df$weather_temperature, na.rm = T)
summary_info$prop_home_favorite <- mean(scores_df$team_home ==
                                          scores_df$team_favorite)
summary_info$prop_favorite_cover <- mean(scores_df$favorite_cover == TRUE)
summary_info$prop_home_favorite_cover <- mean(scores_df$team_favorite ==
                                                scores_df$team_home &
                                                scores_df$favorite_cover == TRUE)