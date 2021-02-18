library(tidyverse)
library(hrbrthemes)
library(viridis)

source("changedf.R")

plot2 <- scores_df %>% 
  ggplot(aes(x = favorite_win, y = abs(score_home - score_away), fill = favorite_win)) +
  geom_boxplot(alpha = 0.3)  +
  scale_fill_brewer(palette = "Dark2") +
  geom_jitter(color="black", size=0.2, alpha=0.25) +
  theme_minimal() +
  theme(
    legend.position="none",
    plot.title = element_text(size=22),
    axis.title.x = element_text(size = 16),
    axis.title.y = element_text(size = 16)
  ) +
  xlab("") + ylab("Point Difference") + xlab("Favorite Won")
plot2
