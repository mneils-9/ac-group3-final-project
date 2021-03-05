library(shiny)
library(shinythemes)

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
  value = -3,
  label = "Spread"
)

week_input <- checkboxGroupInput(
  inputId = "week_input",
  choices = mixedsort(unique(scores_df$schedule_week)),
  label = "Week"
)

year_input <- selectInput(
  inputId = "year_input",
  choices = sort(unique(scores_df$schedule_season)),
  label = "Season"
)

page_one <- tabPanel(
  "Introduction",
  titlePanel("Introduction"),
  mainPanel(
    p("intro stuff"),
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
      plotlyOutput("propspreadcover_plot")
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
  "Finishing Thoughts",
  titlePanel("Finishing Thoughts")
)

dropdownmenu <- navbarMenu(
  "More",
  "----",
  "Section header",
  tabPanel("Table")
)

page_test <- tabPanel(
  "Test Page",
  wellPanel(
    fluidRow(
      column(7,
             wellPanel(style = "background-color: #fff; border-color: #cbcbcb; height: 720px;",
                       plotlyOutput("overunder_plot", height = 680)
             )
      ),
      column(5,
             wellPanel(style = "background-color: #fff; border-color: #cbcbcb; height: 350px;",
                       p("This plokt does...")),  
             wellPanel(style = "background-color: #fff; border-color: #cbcbcb; height: 350px;",
                       p("stuff stuff stuff")))
    )
  )
)



ui <- fluidPage(
  navbarPage(
    theme = shinytheme('flatly'),
    tags$div(tags$img(src='nfllogo.png', width = 64, height = 88, style="float:left; margin-left: 5px; margin-right: 5px; margin-top: -10px")), 
    page_one,         
    page_two,
    page_three,
    page_four,
    page_five,
    page_test
  )
)

