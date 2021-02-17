library(tidyverse)

source("changedf.R")

plot2 <- scores_df %>% 
  ggplot() +
  geom_boxplot(mapping = aes(y = abs(score_home - score_away))) + 
  facet_wrap(~ favorite_cover) +
  labs(y = "Point Difference", title = "Point Difference in favorite_cover FALSE vs. TRUE")
