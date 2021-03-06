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

spread_slider <- knobInput(
  inputId = "spread_slider",
  label = "Spread",
  value = -3,
  min = min(scores_df$spread_favorite),
  max = max(scores_df$spread_favorite),
  step = 0.5,
  thickness = 0.4,
  rotation = "anticlockwise",
  displayPrevious = TRUE,
  lineCap = "default",
  fgColor = "#2C3E50",
  inputColor = "#2C3E50"
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
  icon = icon("i", "fa-info-circle"),
  titlePanel("Introduction"),
  wellPanel(style = "background: #fff",
    fluidRow(
      p("intro stuff"),
    )
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
  wellPanel(style = "background: #fff",
            fluidRow(
              column(1),
              column(3,
                     div(style = "font-size: 10px; padding: 14px; margin-left: 100px; margin-top: 60px"),
                     spread_slider,
                     
              ),
              column(6,
                     wellPanel(style = "background-color: #CACFD3; border-color: #cbcbcb; padding: 4px; width: 800px; height: 410px;",
                               plotOutput("spreadyears_plot")
                     )
              )
            )
  ),
  wellPanel(style = "background: #fff",
            fluidRow(
              wellPanel(
                style = "background-color: #CACFD3; border-color: #cbcbcb; padding: 4px; width: 800px; height: 410px;",
                plotOutput("spreadcomp_plot")
          
              )
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
  icon = icon("i", "fa-check-square"),
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
                       plotlyOutput("ouscorep_plot", height = 320)),  
             wellPanel(style = "background-color: #fff; border-color: #cbcbcb; height: 350px;",
                       p("stuff stuff stuff"))
             )
    )
  )
)

ui <- fluidPage(
  navbarPage(
    theme = shinytheme('flatly'),
    tags$div(tags$img(src='nfllogo.png', width = 29, height = 40, style="float:left; margin-left: 5px; margin-right: 10px; margin-top: -10px"), tags$style(HTML("
      body {
        background-color: #CACFD3;
      }"))), 
    page_one,         
    page_two,
    page_three,
    page_four,
    page_five,
    page_test
  )
)