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
spread_scores_df <- scores_df %>% filter(!is.na(spread_favorite))

# Favorite team for each game.
spread_scores_df <- mutate(spread_scores_df, team_favorite = NA)
for (i in 1:nrow(spread_scores_df)) {
  if (spread_scores_df$team_favorite_id[i] == "PICK") {
    spread_scores_df$team_favorite[i] <- "PICK"
  } else {
    team <- teams %>% 
      filter(team_id == spread_scores_df$team_favorite_id[i]) %>% 
      select(team_name)
    if (is.list(team)) {
      if (spread_scores_df$team_home[i] %in% team) {
        spread_scores_df$team_favorite[i] <- spread_scores_df$team_home[i]
      } else {
        spread_scores_df$team_favorite[i] <- spread_scores_df$team_away[i]
      }
    } else {
      spread_scores_df$team_favorite[i] <- team
    }
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

spread_scores_df <- mutate(spread_scores_df, favorite_win = (team_win == team_favorite))

# New column for if the winner covered spread.
spread_scores_df <- mutate(spread_scores_df, favorite_cover = NA)
for (i in 1:nrow(spread_scores_df)) {
  if (spread_scores_df$favorite_win[i]) {
    if (spread_scores_df$team_win[i] == spread_scores_df$team_home[i]) {
      spread_scores_df$favorite_cover[i] <- (spread_scores_df$score_away[i] - spread_scores_df$score_home[i] < spread_scores_df$spread_favorite[i])
    } else {
      spread_scores_df$favorite_cover[i] <- (spread_scores_df$score_home[i] - spread_scores_df$score_away[i] < spread_scores_df$spread_favorite[i])
    }
  } else {
    spread_scores_df$favorite_cover[i] <- F
  }
}

spread_scores_df <- spread_scores_df[rev(order(as.Date(spread_scores_df$schedule_date))),]

# spread_scores_df %>% group_by(schedule_week) %>%
#   ggplot() +
#   geom_point(mapping = aes(x = schedule_season,y = spread_favorite), color = "#669966", alpha = 0.25) +
#   facet_wrap(~ schedule_week)
  #ggsave("spreadweekyears.png")

# spread_scores_df %>% 
#   group_by(schedule_playoff) %>% 
#   ggplot() +
#   geom_point(mapping = aes(x = schedule_season, y = spread_favorite, color = schedule_playoff), alpha = 0.25) + scale_color_brewer(palette = "Dark2")

# spread_scores_df %>% 
#   ggplot() +
#   geom_point(mapping = aes(x = spread_favorite, y = abs(score_home - score_away), color = favorite_cover), alpha = 0.25)

# spread_scores_df %>% 
#   filter(team_favorite == team_home) %>% 
#   ggplot() +
#   geom_bar(mapping = aes(x = favorite_cover))

# p1 <- ggplot() +
#   geom_histogram(data = scores_df, mapping = aes(x = abs(score_home - score_away)))
# p2 <- ggplot() +
#   geom_histogram(data = pick_df, mapping = aes(x = abs(score_home - score_away)))
# grid.arrange(p1, p2, nrow = 1)

plot2 <- spread_scores_df %>% 
  ggplot() +
  geom_boxplot(mapping = aes(y = abs(score_home - score_away))) + 
  facet_wrap(~ favorite_cover) +
  labs(y = "Point Difference", title = "Point Difference in favorite_cover FALSE vs. TRUE")
