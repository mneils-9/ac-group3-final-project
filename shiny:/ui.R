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
  wellPanel(style = "background: #fff;",
    fluidRow(style = "padding: 30px",
      h2("Domain"),
      p("We chose to look at sports betting in the NFL, which is the practice of placing wagers on football players and games. There is a wide range in the level of participation for sports betting: from casual fans to serious money-making fanatics. Regardless of motivations, all sports bets follow three simple steps: selection, stakes, and odds. The most popular types of sports bets are on point spreads and totals, where people often use statistics to decide on their bet and then wait for the game to be played to see the outcome. Betting is always a gamble, and sports betting involves necessary risk. Sports betting often happens online, which is where this project is focusing. We choose this domain because of a shared interest in sports, and curiosity about the world of football betting. This project will examine trends in National Football League (NFL) betting, especially how the COVID 19 pandemic has affected football betting and team play."),
      h2("Key Terms"),
      p(strong("Spread"), "- the expected point margin by which a team will win or lose by. In other words, how much a team is favored by. A ", em("negative"), " spread implies the team is favored by that amount. A ", em("positive")," spread implies the team is the underdog by that amount." ),
      br(),
      p(strong("Cover the spread"), "- the underdog/favored team was able to win/lose by the certain threshold. An underdog team can either lose by the number of points set in the spread or less and cover the spread. In other words, the underdog is given a handicap. However, the favored team ", em("has"), " to win by the given spread or they will not cover the spread."),
      br(),
      p(strong("Over Under"), "- the expected total number of points scored by both teams in the given game. People can either bet on the over (going to go over the expected total) or the under (going under the expected total)."),
      p(em("E.g."), "he super bowl between the Chiefs and the Buccaneers this year (Super Bowl 55), had a spread of Chiefs -3.5 and an over/under of 57.7. This means that the Chiefs were favored by 3.5 points, and they had to win by 3.5 points or else they wouldn't cover the spread. The Buccaneers on the other hand, could lose by less than 3.5 points or just win to cover the spread. The Buccaneers came out on top 31-9, so Chiefs didn't cover and the game went under since the total points scored was under 57.7."),
      h2("Summary Information")
    ),
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
                       plotlyOutput("pointmargin_plot", height = 320))
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