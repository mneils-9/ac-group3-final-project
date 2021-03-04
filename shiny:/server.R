library(tidyverse)
library(shiny)
library(ggplot2)
library(plotly)
library(viridis)
library(hrbrthemes)

scores_df <- read.csv("../data:/scoresspread.csv")
penalties_df <- read.csv("../data:/penaltiesfull.csv")

server <- function(input, output) {
  output$teamcover_boxplot <- renderPlotly({
    plot <- scores_df %>% 
      filter(input$team_input == team_favorite) %>% 
      ggplot() +
      geom_boxplot(mapping = aes(x = favorite_cover, y = spread_favorite))
    ggplotly(plot)
  })
  
  output$hometeam_cover2020 <- renderPlotly({
    plot <- scores_df %>% 
      filter(schedule_season == 2020) %>% 
      filter(input$ht_input == team_favorite) %>% 
      ggplot() +
      geom_bar(mapping = aes(x = favorite_cover), fill = viridis(2)) +
      theme_minimal() + 
      xlab("Home Favorite Cover") + ggtitle("2020")
    
    ggplotly(plot)
  })
  
  output$hometeam_cover <- renderPlotly({
    plot <- scores_df %>% 
      filter(input$ht_input == team_favorite) %>% 
      ggplot() +
      geom_bar(mapping = aes(x = favorite_cover), fill = viridis(2)) +
      theme_minimal() + 
      xlab("Home Favorite Cover") + ggtitle("1967-2020")
    
    ggplotly(plot)
  })
  
  output$spreadslider_plot <- renderPlotly({
    plot <- scores_df %>% 
      filter(scores_df$spread_favorite >= input$spread_slider[1] & scores_df$spread_favorite <= input$spread_slider[2]) %>% 
      ggplot() +
      geom_histogram(mapping = aes(x = score_home + score_away, color = favorite_cover), alpha = 0.5, fill = "white") +
      scale_fill_manual(values = c("#00AFBB", "#E7B800")) +
      scale_color_manual(values = c("#00AFBB", "#E7B800")) +
      theme_ipsum()
  })
}