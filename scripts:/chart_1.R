# Maddie: Chart: Has the accuracy of projected favorites changed 
# in the 2020 season?

library(tidyverse)
library(ggplot2)

# Read in data.
scores_df <- read.csv("data:/spreadspoke_scores.csv")
teams <- read.csv("data:/teamanno.csv")

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
spread_scores_df <- scores_df %>% filter(!is.na(spread_favorite))

# Average spread of each season.
avg_spreads <- spread_scores_df %>% 
  group_by(schedule_season) %>% 
  summarize(avg_spread = mean(spread_favorite))

# Favorite team for each game.
spread_scores_df <- mutate(spread_scores_df, team_favorite = NA)
for (i in 1:nrow(spread_scores_df)) {
  if (spread_scores_df$team_favorite_id[i] == "PICK") {
    spread_scores_df$team_favorite[i] <- "PICK"
  } else {
    teams_df_get_name <- match(spread_scores_df$team_favorite_id[i], 
                               teams$Abbreviation, nomatch = NA_integer_, incomparables = NULL) 
    spread_scores_df$team_favorite[i] <- teams$Name[teams_df_get_name]
  }
}

# Team won for each game.
spread_scores_df <- mutate(spread_scores_df, team_win = NA)
for (i in 1:nrow(spread_scores_df)) {
  if (spread_scores_df$home_win[i]) {
    spread_scores_df$team_win[i] <- spread_scores_df$team_home[i]
  } else {
    spread_scores_df$team_win[i] <- spread_scores_df$team_away[i]
  }
}

# New column for if the projected favorite won the game
spread_scores_df <- mutate(spread_scores_df, favorite_win = (team_win == team_favorite))

# New column for percent accuracy
spread_scores_df <- mutate(spread_scores_df, percent_accuracy = NA)
for (i in 1:nrow(spread_scores_df)) {
  if(spread_scores_df$favorite_win[i]){
    spread_scores_df$percent_accuracy[i] <- 100
  }
  else {
    spread_scores_df$percent_accuracy[i] <- 0
  }
}

# Dataframe for % accuracy of projections by year
projection_accuracy <- spread_scores_df %>%
  select(schedule_season, team_favorite, team_win, favorite_win, percent_accuracy)

yearly_projection_accuracy <- projection_accuracy %>%
  group_by(schedule_season) %>%
  summarise (mean(percent_accuracy))
  
# Make plot!
plot1 <- ggplot(data = yearly_projection_accuracy) +
  geom_point(mapping = aes(x = schedule_season, y = `mean(percent_accuracy)`),color = "#013369")+
  geom_smooth(mapping = aes(x = schedule_season, y = `mean(percent_accuracy)`), color = "#D50A0A") +
  theme_minimal() +
  labs(
    title = "The Average Accuracy of Projected Favorites by Season",
    x = "Season (Year)",
    y = "Percent Accuracy"
  )


