require(tidyverse)
require(shiny)
require(ggplot2)
require(plotly)
require(viridis)
require(hrbrthemes)
require(gtools)
require(shinythemes)
require(shinyWidgets)
require(shinymaterial)
require(DT)

# Read in data
scores_df <- read.csv("data:/scoresspread.csv")
o_histdf <- read.csv("data:/offensehistory.csv")
penalties_df <- read.csv("data:/penaltiesfull.csv")
source("scripts:/summaryinfo.R")

# Ordered week
week_ordered <- c("1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "Wildcard", "Division", "Conference", "Superbowl")

order_week <- function(list) {
  week_ordered[week_ordered %in% list]
}

quantify_week <- function(df) {
  df$schedule_week[df$schedule_week == "18"] <- 17
  df$schedule_week[df$schedule_week == "Wildcard"] <- 18
  df$schedule_week[df$schedule_week == "Division"] <- 19
  df$schedule_week[df$schedule_week == "Conference"] <- 20
  df$schedule_week[df$schedule_week == "Superbowl"] <- 21

  df
}

cc <- scales::seq_gradient_pal("#2C3E50", "#E5E3E7", "Lab")(seq(0, 5, length.out = 22))

server <- function(input, output) {
  output$num_obs <- renderText({
    return(summary_info$num_obs)
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

  # Weeks & Seasons Average Spread
  output$week_spreadplot <- renderPlotly({
    if (length(input$week_input) != 0) {
      plot <- scores_df %>%
        filter(scores_df$schedule_week %in% input$week_input) %>%
        group_by(schedule_season, schedule_week) %>%
        summarize(spread_avg = mean(spread_favorite, na.rm = T)) %>%
        ggplot() +
        geom_line(mapping = aes(x = schedule_season, y = spread_avg, color = schedule_week)) +
        scale_color_manual(values = cc) +
        labs(y = "Spread", x = "Season", color = "Week") +
        theme_ipsum()
      ggplotly(plot)
    } else {
      scores_df %>%
        ggplot() +
        theme_ipsum()
    }
  })

  # Uncertainty in the Over/Under Lines
  output$ou_boxplot <- renderPlotly({
    ifelse(input$playoff_input, ou_df <- scores_df, ou_df <- scores_df %>% filter(schedule_playoff == FALSE))

    ou_df <- quantify_week(ou_df)

    avg_df <- ou_df %>%
      group_by(schedule_week) %>%
      summarize(avg_ou = mean(over_under_line, na.rm = T), avg_total = mean(score_home + score_away, na.rm = T))

    ou_df <- ou_df %>%
      mutate(schedule_week = as.numeric(schedule_week)) %>%
      filter(schedule_season == input$year_input2)

    season_df <- ou_df %>%
      group_by(schedule_week) %>%
      summarize(avg_ou = mean(over_under_line, na.rm = T), avg_total = mean(score_home + score_away, na.rm = T))

    plot <- ggplot()

    if (input$opacitybp_input == 0) {
      plot <- plot + geom_blank() + theme_ipsum()
    } else {
      plot <- plot + geom_boxplot(data = ou_df, aes(x = as.numeric(schedule_week), y = over_under_line), color = "#566573", fill = "#939DA5", alpha = input$opacitybp_input) +
        xlim(-0.25, 21) + labs(x = "Week", y = "Points") +
        theme_ipsum() +
        theme(legend.position = "right")
    }

    if ("Overall O/U Line" %in% input$trend_input) {
      plot <- plot + geom_line(data = avg_df, aes(x = as.numeric(schedule_week), y = avg_ou, color = "overallou"))
    }

    if ("Overall Total Points" %in% input$trend_input) {
      plot <- plot + geom_line(data = avg_df, aes(x = as.numeric(schedule_week), y = avg_total, color = "overalltotpts"), linetype = "dashed")
    }

    if ("Season O/U Line" %in% input$trend_input) {
      plot <- plot + geom_line(data = season_df, aes(x = as.numeric(schedule_week), y = avg_ou, color = "seasonou"))
    }

    if ("Season Total Points" %in% input$trend_input) {
      plot <- plot + geom_line(data = season_df, aes(x = as.numeric(schedule_week), y = avg_total, color = "seasontotpts"), linetype = "dashed")
    }

    plot <- plot +
      scale_colour_manual(
        name = "Trend Line",
        values = c(overallou = "#013369", overalltotpts = "#013369", seasonou = "#013369", seasontotpts = "#013369")
      ) + xlab("Week") + ylab("Points")

    ggplotly(plot)
  })

  # Betting Accuracy
  output$bets_accuracy_plot <- renderPlotly({
    # Dataframe for % accuracy of projections by year
    projection_accuracy <- scores_df %>%
      select(
        schedule_season, team_favorite, team_win, favorite_win,
        percent_accuracy
      )

    yearly_projection_accuracy <- projection_accuracy %>%
      group_by(schedule_season) %>%
      summarise(percent_accuracy = mean(percent_accuracy))

    # Make plot!
    plot1 <- ggplot(data = yearly_projection_accuracy) +
      geom_point(
        mapping = aes(x = schedule_season, y = percent_accuracy),
        color = "#013369"
      ) +
      geom_smooth(
        mapping = aes(x = schedule_season, y = percent_accuracy),
        color = "#D50A0A", method = "loess", formula = y ~ x
      ) +
      theme_minimal() +
      labs(
        x = "Season (Year)",
        y = "Percent Accuracy"
      )
    ggplotly(plot1)
  })

  output$team_season_accuracy <- renderPlotly({
    plot <- scores_df %>%
      filter(schedule_season == input$year_input) %>%
      filter(team_home == input$team_input) %>%
      ggplot(aes(x = schedule_date, y = percent_accuracy)) +
      geom_bar(
        mapping = aes(schedule_date, percent_accuracy),
        color = "#013369", stat = "identity"
      ) +
      theme_minimal() +
      labs(x = "Game Date", y = "Accuracy of Prediction")
    ggplotly(plot)
  })

  # Finishing Thoughts table
  output$aggragate_table <- renderDataTable({
    summarytable <- scores_df %>%
      filter(team_favorite == team_home) %>%
      group_by(team_favorite) %>%
      summarise(average_homescore = mean(score_home)) %>%
      rename("Team" = "team_favorite", "Avg. Score" = "average_homescore")
    datatable(summarytable, options = list(pageLength = 10))
  })
}
