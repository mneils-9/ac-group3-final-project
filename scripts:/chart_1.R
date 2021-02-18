# Maddie: Chart: Has the accuracy of projected favorites changed 
# in the 2020 season?

library(tidyverse)
library(ggplot2)

source("changedf.R")


# Dataframe for % accuracy of projections by year
projection_accuracy <- scores_df %>%
  select(schedule_season, team_favorite, team_win, favorite_win, percent_accuracy)

yearly_projection_accuracy <- projection_accuracy %>%
  group_by(schedule_season) %>%
  summarise (mean(percent_accuracy))
  
# Make plot!
plot1 <- ggplot(data = yearly_projection_accuracy) +
  geom_point(mapping = aes(x = schedule_season, y = `mean(percent_accuracy)`),color = "#013369")+
  geom_smooth(mapping = aes(x = schedule_season, y = `mean(percent_accuracy)`), color = "#D50A0A", method = "loess", formula = y ~x) +
  theme_minimal() +
  labs(
    title = "The Average Percent Accuracy of Projected Favorites by Season",
    x = "Season (Year)",
    y = "Percent Accuracy"
  )

plot1

