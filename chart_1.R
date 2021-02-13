# Maddie: Chart: are home teams still favorited in 2020 season?

library(tidyverse)

# Read in data.
scores_df <- read.csv("data:/spreadspoke_scores.csv")
teams <- read.csv("data:/teamanno.csv")

source(light_analysis.R)

projection_accuracy <- spread_scores_df$favorite_win

