library(tidyverse)
library(shiny)
library(ggplot2)
library(plotly)
library(viridis)
library(hrbrthemes)
library(gtools)
library(shinyWidgets)

scores_df <- read.csv("../data:/scoresspread.csv")
o_histdf <- read.csv("../data:/offensehistory.csv")
penalties_df <- read.csv("../data:/penaltiesfull.csv")
source("/scripts/summaryinfo.R")

server <- function(input, output) {
  
  output$num_obs <- renderText({
    return(summary_info$num_ob)
  })
  
  output$num_unique_years <- renderText({
    return(summary_info$num_unique_years)
  })
  
  output$num_different_teams <- renderText({
    return(summary_info$num_different_teams)
  })
  
  output$favorite_min_spread <- renderText({
    return(summary_info$favorite_min_spread)
  })
  
  output$favorite_max_spread <- renderText({
    return(summary_info$favorite_max_spread)
  })
  
  output$favorite_spread_mean <- renderText({
    return(summary_info$favorite_spread_mean)
  })
  
  output$prop_home_favorite <- renderText({
    return(summary_info$prop_home_favorite)
  })
  
  output$prop_home_favorite_cover <- renderText({
    return(summary_info$prop_home_favorite_cover)
  })
  
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
      mutate(favorite_score = ifelse(team_favorite == team_home, score_home, score_away)) %>% 
      filter(spread_favorite >= input$spread_slider[1] & spread_favorite <= input$spread_slider[2]) %>% 
      ggplot() +
      geom_point(mapping = aes(x = spread_favorite, y = favorite_score, color = favorite_cover)) +
      scale_color_viridis_d() +
      theme_ipsum()
      # geom_histogram(mapping = aes(x = favorite_score, color = favorite_cover), alpha = 0.5, fill = "white") +
      # scale_fill_manual(values = c("#00AFBB", "#E7B800")) +
      # scale_color_manual(values = c("#00AFBB", "#E7B800")) +
      # theme_ipsum()
  })
  
  output$week_spreadplot <- renderPlotly({
    if (length(input$week_input) != 0) {
      plot <- scores_df %>% 
        filter(scores_df$schedule_week %in% input$week_input) %>% 
        group_by(schedule_season, schedule_week) %>% 
        summarize(spread_avg = mean(spread_favorite, na.rm = T)) %>% 
        ggplot() +
        geom_line(mapping = aes(x = schedule_season, y = spread_avg, color = schedule_week)) + 
        scale_color_viridis_d() +
        theme_ipsum()
      ggplotly(plot)
    } else {
      scores_df %>% 
        ggplot() +
        geom_blank() +
        theme_ipsum()
    }
  })
  
  output$yearweek_plot <- renderPlotly({
    plot <- scores_df %>% 
      filter(schedule_season == input$year_input) %>% 
      ggplot() +
        geom_bar(mapping = aes(x = schedule_week, y = favorite_cover, fill = favorite_cover), position = "stack", stat = "identity") + 
        scale_color_viridis_d() +
        theme_ipsum()
    ggplotly(plot)
  })
  
  output$propcover_plot <- renderPlotly({
    
    coeff <- 100
    
    plot <- scores_df %>% 
      group_by(schedule_season) %>% 
      summarize(prop = mean(favorite_cover), spread = mean(spread_favorite)) %>% 
      filter(prop > 0 & prop < 1) %>% 
      ggplot(aes(x = schedule_season)) +
      geom_bar(aes(y = prop, fill = prop), stat = "identity") +
      geom_line(aes(y = abs(spread) / coeff)) +
      scale_fill_viridis_c() +
      scale_y_continuous(
        name = "Proportion Cover",
        sec.axis = sec_axis(~.*coeff, name = "Average Spread")
      ) +
      theme_ipsum()
    ggplotly(plot)
  })
  
  output$propspreadcover_plot <- renderPlotly({
    plot <- scores_df %>% 
      filter(input$spread_slider >= spread_favorite) %>% 
      group_by(spread_favorite) %>% 
      summarize(prop = mean(favorite_cover)) %>% 
      ggplot(aes(x = spread_favorite)) +
      geom_bar(aes(y = prop, fill = prop), stat = "identity") +
      scale_fill_viridis_c() +
      theme_ipsum()
    ggplotly(plot)
  })
  
  output$spreadyears_plot <- renderPlot({
    plot <- scores_df %>% 
      filter(input$spread_slider == spread_favorite) %>% 
      group_by(schedule_season, favorite_cover) %>% 
      summarize(count = n()) %>% 
      ggplot() +
      geom_bar(mapping = aes(x = schedule_season, y = count, fill = favorite_cover), position="stack",  stat = "identity")  +
      scale_fill_manual(name = "", labels = c("Favorite Didn't Cover Spread", "Favorite Covered Spread"), values = c("FALSE" = "#2C3E50", "TRUE" = "#939DA5")) +
      theme_ipsum() +
      theme(legend.position = "top")
    plot
  })
  
  output$overunder_plot <- renderPlotly({
    plot <- scores_df %>% 
      filter(schedule_season >= 1980) %>% 
      group_by(schedule_season) %>% 
      summarize(ou = mean(over_under_line, na.rm = T), total = mean(score_home + score_away, na.rm = T)) %>% 
      ggplot(aes(x = schedule_season)) +
      geom_line(aes(y = ou), color = "#2C3E50") +
      geom_line(aes(y = total), color = "#939DA5") +
      theme_ipsum() 
    ggplotly(plot)
  })
  
  output$spreadcomp_plot <- renderPlot({
    plot <- scores_df %>% 
      mutate(is2020 = schedule_season == 2020) %>% 
      group_by(schedule_season, spread_favorite) %>% 
      summarize(count = n(), is2020) %>% 
      group_by(is2020, spread_favorite) %>% 
      summarize(avg = mean(count)) %>% 
      ggplot(aes(x = spread_favorite)) +
      geom_bar(aes(y = avg, fill = is2020), stat = "identity", position = position_dodge()) +
      scale_fill_manual(name = "", labels = c("1966-2019", "2020"), values = c("FALSE" = "#2C3E50", "TRUE" = "#939DA5")) + 
      labs(x = "Spread", y = "Count") +
      theme_ipsum() +
      theme(legend.position = "top")
    plot
  })
  
  output$ouscorep_plot <- renderPlotly({
    avgou <- scores_df %>% 
      group_by(schedule_season) %>% 
      summarize(ou = mean(over_under_line, na.rm = T))
    
    avgou <- left_join(o_histdf %>% select(year, scoreperc), avgou, by = c("year" = "schedule_season")) 
    
    plot <- avgou %>% 
      filter(year >= 1998) %>% 
      ggplot(aes(x = year)) +
      geom_line(aes(y = ou)) +
      geom_line(aes(y= scoreperc)) +
      theme_ipsum()
    ggplotly(plot)
  })
  
  output$pointmargin_plot <- renderPlotly({
    plot <- scores_df %>%
      mutate(margin = abs(score_home - score_away)) %>% 
      ggplot() + 
      geom_histogram(aes(x = schedule_season, y = margin, fill = favorite_win)) +
      theme_ipsum()
    
    ggplotly(plot)
  })
  
  output$table <- renderTable({
    o_histdf %>% 
      group_by(year) %>% 
      select(year, ptd, pint, rtd)
  })
  
  output$summary <- renderText({
    "blah blah blah"
  })
  
  output$bets_accuracy_plot <- renderPlotly({
    # Dataframe for % accuracy of projections by year
    projection_accuracy <- scores_df %>%
      select(schedule_season, team_favorite, team_win, favorite_win,
             percent_accuracy)
    
    yearly_projection_accuracy <- projection_accuracy %>%
      group_by(schedule_season) %>%
      summarise(mean(percent_accuracy))
    
    # Make plot!
    plot1 <- ggplot(data = yearly_projection_accuracy) +
      geom_point(mapping = aes(x = schedule_season, y = `mean(percent_accuracy)`),
                 color = "#013369") +
      geom_smooth(mapping = aes(x = schedule_season, y = `mean(percent_accuracy)`),
                  color = "#D50A0A", method = "loess", formula = y ~x) +
      theme_minimal() +
      labs(
        x = "Season (Year)",
        y = "Percent Accuracy"
      )
    ggplotly(plot1)
    
  })
}