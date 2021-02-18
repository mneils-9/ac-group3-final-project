library(tidyverse)

# Read in data.
scores_df <- read.csv("../data:/spreadspoke_scores.csv")
teams <- read.csv("../data:/nfl_teams.csv")

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

# Create a dataframe with rows containing spread data.
scores_df <- scores_df %>% filter(!is.na(spread_favorite))

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

# # Favorite team for each game.
# scores_df <- mutate(scores_df, team_favorite = NA)
# for (i in 1:nrow(scores_df)) {
#   if (scores_df$team_favorite_id[i] == "PICK") {
#     sscores_df$team_favorite[i] <- "PICK"
#   } else {
#     teams_df_get_name <- match(scores_df$team_favorite_id[i],
#                                teams$Abbreviation, nomatch = NA_integer_, incomparables = NULL)
#     scores_df$team_favorite[i] <- teams$Name[teams_df_get_name]
#   }
# }


# Team won for each game.
scores_df <- mutate(scores_df, team_win = NA)
for (i in 1:nrow(scores_df)) {
  if (scores_df$home_win[i]) {
    scores_df$team_win[i] <- scores_df$team_home[i]
  } else {
    scores_df$team_win[i] <- scores_df$team_away[i]
  }
}

# If the favorite won the game.
scores_df <- mutate(scores_df, favorite_win = (team_win == team_favorite))

# If the favorite covered the spread.
scores_df <- mutate(scores_df, favorite_cover = NA)
for (i in 1:nrow(scores_df)) {
  if (scores_df$favorite_win[i]) {
    if (scores_df$team_win[i] == scores_df$team_home[i]) {
      scores_df$favorite_cover[i] <- (scores_df$score_away[i] - scores_df$score_home[i] < scores_df$spread_favorite[i])
    } else {
      scores_df$favorite_cover[i] <- (scores_df$score_home[i] - scores_df$score_away[i] < scores_df$spread_favorite[i])
    }
  } else {
    scores_df$favorite_cover[i] <- F
  }
}


# New column for percent accuracy
scores_df <- mutate(scores_df, percent_accuracy = NA)
for (i in 1:nrow(scores_df)) {
  if(scores_df$favorite_win[i]){
    scores_df$percent_accuracy[i] <- 100
  }
  else {
    scores_df$percent_accuracy[i] <- 0
  }
}
