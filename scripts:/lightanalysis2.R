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
spread_scores_df <- scores_df %>% filter(!is.na(spread_favorite))

# Average spread of each season.
avg_spreads <- spread_scores_df %>% 
  group_by(schedule_season) %>% 
  summarize(avg_spread = mean(spread_favorite))

# Average ou of each season.
avg_ous <- spread_scores_df %>% 
  group_by(schedule_season) %>% 
  summarise(avg_ou = mean(over_under_line, na.rm = TRUE))

# Join dataframes.
year_score_df <- left_join(prop_home_win, avg_spreads)

# Join dataframes.
year_score_df <- left_join(year_score_df, avg_ous)

# Filter for only superbowl data.
sb_spreads <- spread_scores_df %>% 
  filter(schedule_week == "Superbowl") 

# Plot the average spread of favorite over the seasons.
# theme_set(theme_grey())
# ggplot(data = sb_spreads) +
#   geom_line(mapping = aes(x = schedule_season, y = spread_favorite), color = "skyblue4") +
#   xlab("Season") +
#   ylab("Avg. Spread") +
#   theme(text = element_text(size = 10,  family = "mono"))

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

# spread_scores_df <- mutate(spread_scores_df, favorite_win = str_detect(team_win, str_split(team_favorite, " ")[[1]][length(str_split(team_favorite, " ")[[1]])]))

# Whether favorite team won or not.

# spread_scores_df %>% group_by(schedule_week) %>% 
#   ggplot() +
#   geom_point(mapping = aes(x = schedule_season,y = spread_favorite), color = "#56B4E9", alpha = 0.25) +
#   facet_wrap(~ schedule_week) +
#   ggsave("spreadweekyears.png")
  
# Plot proportion home wins over the years.
# ggplot() +
#   geom_line(data = year_score_df, aes(x = schedule_season, y = prop_home_wins), color = "darkcyan") +
#   ggsave("homewins.png")

# Plot avg ou over the years.
# ggplot() +
#   geom_line(data = year_score_df, aes(x = schedule_season, y = avg_ou), color = "darkcyan") +
#   ggsave("ou.png")

# Plot avg line over the years.
# ggplot() +
#   geom_line(data = year_score_df, aes(x = schedule_season, y = avg_spread), color = "darkcyan") +
#   ggsave("avgline.png")

# Plot range of spreads for each week            
# spread_scores_df %>%
#   filter(schedule_season == 2020) %>%
#   ggplot(aes(x = spread_favorite, xend = spread_favorite, 
#              y = schedule_week, group = schedule_week)) + 
#   geom_dumbbell(color="#a3c4dc", size=0.75, point.colour.l="#0e668b")

# Plots the spreads for each week different visual
# g <- spread_scores_df %>% 
#   filter(schedule_season == 2020) %>% 
#   arrange(schedule_date, decreasing = TRUE) %>% 
#   ggplot(aes(schedule_week, spread_favorite))
# g + geom_tufteboxplot() + 
#   theme(axis.text.x = element_text(angle=65, vjust=0.6))
