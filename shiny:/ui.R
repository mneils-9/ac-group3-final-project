library(shiny)

scores_df <- read.csv("../data:/scoresspread.csv")

team_input <- selectInput(
  inputId = "team_input",
  choices = sort(unique(scores_df$team_home)),
  label = "Select Team"
)

team_input2 <- selectInput(
  inputId = "team_input2",
  choices = sort(unique(scores_df$team_home)),
  label = "Select Team"
)

ht_input <- selectInput(
  inputId = "ht_input",
  choices = scores_df %>% 
    filter(schedule_season == 2020) %>% 
    select(team_home) %>% 
    unique() %>% 
    arrange(team_home),
  label = "2020 Season"
)

spread_slider <- sliderInput(
  inputId = "spread_slider",
  max = max(scores_df$spread_favorite),
  min = min(scores_df$spread_favorite),
  value = c(-3,-7),
  label = "Spread"
)

page_one <- tabPanel(
  "Introduction",
  titlePanel("Introduction"),
  mainPanel(
    p("intro stuff")
  )
)

page_two <- tabPanel(
  "Interactive Visuals Part 1", 
  titlePanel("Interactive Visuals Part 1"),
  sidebarLayout(
    sidebarPanel(
      "Side stuff"
    ),
    mainPanel(
      "Main stuff"
    )
  )
)

page_three <- tabPanel(
  "Interactive Visuals Part 2",
  titlePanel("Interactive Visuals Part 2"),
  sidebarLayout(
    sidebarPanel(
      spread_slider
    ),
    mainPanel(
      # splitLayout(cellWidths = c("50%", "50%"), plotlyOutput("plottest4"), plotlyOutput("plottest5"))
      plotlyOutput("spreadslider_plot")
    )
  )
)

page_four <- tabPanel(
  "Interacetive Visuals Part 3",
  titlePanel("Interactive Visuals Part 3"),
  sidebarLayout(
    sidebarPanel(
      "Side stuff"
    ),
    mainPanel(
      "Main stuff"
    )
  )
)

page_five <- tabPanel(
  "Conclusion",
  titlePanel("Conclusion")
)

ui <- fluidPage(
  navbarPage(
    "NFL Betting 2020",
    page_one,         
    page_two,
    page_three,
    page_four,
    page_five
  )
)

