# Kobe: Chart - Are there different game outcomes for when the home team
# is favored?
library(tidyverse)

scores_df <- read.csv("../data:/scoresspread.csv")

scores_df %>%
  mutate(home_favorite = team_favorite == team_home) %>%
  ggplot(aes(x = home_favorite, y = abs(score_home - score_away),
             fill = favorite_win)) +
  geom_boxplot(alpha = 0.50) +
  scale_fill_manual(values = c("#D50A0A", "#013369")) +
  geom_jitter(color = "black", size = 0.2, alpha = 0.25) +
  theme_minimal() +
  theme(
    legend.position = c(0.94, 0.90),
    plot.title = element_text(size = 22),
    axis.title.x = element_text(size = 16),
    axis.title.y = element_text(size = 16),
    strip.text = element_blank()
  ) +
  xlab("") + ylab("Point Differential of Game") + xlab("Home Favorite")
