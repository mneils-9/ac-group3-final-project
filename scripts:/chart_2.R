library(tidyverse)

# Read in team annotation data.
teams <- read.csv("data:/teamanno.csv")
# Read in data.
scores_df <- read.csv("data:/spreadspoke_scores.csv")

# Reformat date
scores_df$schedule_date <- as.Date(scores_df$schedule_date, format = "%m/%d/%Y")

# Change SuperBowl to Superbowl and WildCard to Wildcard (2017 season)
scores_df[scores_df$schedule_week == "SuperBowl", "schedule_week"] <- "Superbowl"
scores_df[scores_df$schedule_week == "WildCard", "schedule_week"] <- "Wildcard"

# Make new column for home win.
scores_df <- scores_df %>% mutate(home_win = (score_home > score_away))

# Only include data that include spread.
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