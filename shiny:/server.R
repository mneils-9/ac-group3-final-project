library(tidyverse)
library(shiny)
library(ggplot2)
library(plotly)
library(viridis)
library(hrbrthemes)

scores_df <- read.csv("../data:/scoresspread.csv")

server <- function(input, output) {
  output$plottest <- renderPlotly({
    plot <- scores_df %>% 
      filter(input$team_input == team_favorite) %>% 
      ggplot() +
      geom_boxplot(mapping = aes(x = favorite_cover, y = spread_favorite))
    ggplotly(plot)
  })
}