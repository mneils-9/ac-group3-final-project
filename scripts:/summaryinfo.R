library(tidyverse)

# Read in data.
scores_df <- read.csv("data:/spreadspoke_scores.csv")
teams <- read.csv("data:/nfl_teams.csv")

# Reformat date
scores_df$schedule_date <- as.Date(scores_df$schedule_date, format = "%m/%d/%Y")

# Change SuperBowl to Superbowl and WildCard to Wildcard (2017 season)
scores_df[scores_df$schedule_week == "SuperBowl", "schedule_week"] <- "Superbowl"
scores_df[scores_df$schedule_week == "WildCard", "schedule_week"] <- "Wildcard"

# Input scores for latest Superbowl
scores_df[scores_df$schedule_date == "2021-02-07", "score_home"] <- 9
scores_df[scores_df$schedule_date == "2021-02-07", "score_away"] <- 31

# Add a new column to the dataframe where it tells us if the home team won/lost.
scores_df <- scores_df %>% mutate(home_win = (score_home > score_away))

# Proportion of home teams that won in each season. 
prop_home_win <- scores_df %>% 
  group_by(schedule_season) %>% 
  filter(home_win == TRUE, .preserve = TRUE) %>% 
  summarise(prop = n()) %>%
  mutate(prop_home_wins = prop / sum(prop))

# Create a dataframe with rows containing spread data.
scores_df <- scores_df %>% filter(!is.na(spread_favorite))

# Average spread of each season.
avg_spreads <- scores_df %>% 
  group_by(schedule_season) %>% 
  summarize(avg_spread = mean(spread_favorite))

# Average ou of each season.
avg_ous <- scores_df %>% 
  group_by(schedule_season) %>% 
  summarise(avg_ou = mean(over_under_line, na.rm = TRUE))

# Join dataframes.
year_score_df <- left_join(prop_home_win, avg_spreads)

# Join dataframes.
year_score_df <- left_join(year_score_df, avg_ous)

# Filter for only superbowl data.
sb_spreads <- scores_df %>% 
  filter(schedule_week == "Superbowl") 

# Favorite team for each game.
scores_df <- mutate(scores_df, team_favorite = NA)
for (i in 1:nrow(scores_df)) {
  if (scores_df$team_favorite_id[i] == "PICK") {
    scores_df$team_favorite[i] <- "PICK"
  } else {
    team <- teams %>% 
      filter(team_id == scores_df$team_favorite_id[i]) %>% 
      select(team_name)
    if (is.list(team)) {
      if (scores_df$team_home[i] %in% team) {
        scores_df$team_favorite[i] <- scores_df$team_home[i]
      } else {
        scores_df$team_favorite[i] <- scores_df$team_away[i]
      }
    } else {
      scores_df$team_favorite[i] <- team
    }
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

scores_df <- mutate(scores_df, favorite_win = (team_win == team_favorite))

scores_df <- mutate(scores_df, favorite_cover = NA)
for (i in 1:nrow(scores_df)) {
  if (scores_df$favorite_win[i]) {
    if (scores_df$team_win[i] == scores_df$team_home) {
      scores_df$favorite_cover[i] <- (scores_df$score_away[i] - scores_df$score_home[i] < scores_df$spread_favorite[i])
    } else {
      scores_df$favorite_cover[i] <- (scores_df$score_home[i] - scores_df$score_away[i] < scores_df$spread_favorite[i])
    }
  } else {
    scores_df$favorite_cover[i] <- F
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