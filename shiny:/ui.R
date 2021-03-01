library(shiny)

scores_df <- read.csv("../data:/scoresspread.csv")

page_one <- tabPanel(
  "Introduction",
  titlePanel("Introduction"),
  mainPanel(
    p("intro stuff")
  )
)

page_two <- tabPanel(
  "Interactive Visuals", 
  titlePanel("Interactive Visuals"),
  sidebarLayout(
    sidebarPanel(
      team_input
    ),
    mainPanel(
      plotlyOutput("plottest")
    )
  )
)

team_input <- selectInput(
  inputId = "team_input",
  choices = sort(unique(scores_df$team_home)),
  label = "Select Team"
)

ui <- fluidPage(
  navbarPage(
    "NFL Betting 2020",
    page_one,         
    page_two
  )
)