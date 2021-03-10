library(tidyverse)
library(ggplot2)
library(dplyr)

scores_df <- read.csv("../data:/scoresspread.csv")

top10_summary <- scores_df %>% 
  filter(team_favorite == team_home) %>% 
  group_by(team_favorite) %>% 
  summarise(average_homescore=mean(score_home)) %>% 
  top_n(10)  %>% 
  arrange(average_homescore) %>% 
  ggplot()+
  geom_bar(mapping = aes(x= average_homescore, y= reorder(team_favorite, -average_homescore),fill = average_homescore), stat = "identity")  + 
  scale_color_manual(values = c("#013369","#D50A0A")) +
  ylab("Team") + xlab("Average Home Score") 
top10_summary

