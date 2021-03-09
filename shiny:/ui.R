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

year_input2 <- selectInput(
  inputId = "year_input2",
  choices = scores_df %>% filter(schedule_season > 1978) %>% select(schedule_season) %>% unique() %>% arrange(),
  label = "Season"
)

playoff_input <- radioButtons(
  inputId = "playoff_input",
  choices = list("True" = TRUE, "False" = FALSE),
  selected = FALSE,
  label = "Include Playoffs"
)

page_one <- tabPanel(
  "Introduction", 
  style = "margin-top: -20px",
  icon = icon("i", "fa-info-circle"),
  titlePanel("Introduction"),
  wellPanel(style = "margin-top: 20px",
            fluidRow(style = "padding: 30px; margin-top: -20px; margin-bottom: -20px", tags$head(tags$style("#container * { display: inline; }")),
                     div(id="container",
                         h2("Domain"),
                         br(),
                         br(),
                         p("We chose to look at sports betting in the NFL, which is the practice of 
        placing wagers on football players and games. There is a wide range in 
        the level of participation for sports betting: from casual fans to 
        serious money-making fanatics. Regardless of motivations, all sports 
        bets follow three simple steps: selection, stakes, and odds. The most 
        popular types of sports bets are on point spreads and totals, where 
        people often use statistics to decide on their bet and then wait for the
        game to be played to see the outcome. Betting is always a gamble, and 
        sports betting involves necessary risk. Sports betting often happens 
        online, which is where this project is focusing. We choose this domain 
        because of a shared interest in sports, and curiosity about the world of
        football betting. This project will examine trends in National Football 
        League (NFL) betting, especially how the COVID 19 pandemic has affected 
        football betting and team play."),
                         br(),
                         br(),
                         br(),
                         img(src = 'betting_infographic.PNG', alt = "US sports betting infographic", height="60%", width="60%", style = "display: block; margin-left: auto; margin-right: auto;"),
                         br(),
                         p(em("This infographic, ", tags$a(href="https://www.economist.com/graphic-detail/2019/12/29/as-much-as-26bn-could-be-gambled-on-american-sport-in-2020", "by the Economist"), ", shows which states have legalized sports gambling on 
        the map and the bar chart on the side shows the rapid growth of legal 
        sports bets in the last few years.")),
                         br(),
                         br(),
                         h2("Key Terms"),
                         br(),
                         br(),
                         p(strong("Spread"), "- the expected point margin by which a team will win 
        or lose by. In other words, how much a team is favored by. A ", 
                           em("negative"), " spread implies the team is favored by that amount. A ",
                           em("positive")," spread implies the team is the underdog by that amount." ),
                         br(),
                         p(strong("Cover the spread"), "- the underdog/favored team was able to 
        win/lose by the certain threshold. An underdog team can either lose by 
        the number of points set in the spread or less and cover the spread. In 
        other words, the underdog is given a handicap. Moreover, the favored team ",
                           em("has"), " to win by the given spread or they will not cover the spread."),
                         br(),
                         p(strong("Over Under"), "- the expected total number of points scored by 
        both teams in the given game. People can either bet on the over (going 
        to go over the expected total) or the under (going under the expected 
        total)."),
                         br(),
                         p(em("E.g."), "he super bowl between the Chiefs and the Buccaneers this 
        year (Super Bowl 55), had a spread of Chiefs -3.5 and an over/under of 
        57.7. This means that the Chiefs were favored by 3.5 points, and they 
        had to win by 3.5 points or else they wouldn't cover the spread. The 
        Buccaneers on the other hand, could lose by less than 3.5 points or just
        win to cover the spread. The Buccaneers came out on top 31-9, so Chiefs
        didn't cover and the game went under since the total points scored was 
        under 57.7."),
                         br(),
                         br(),
                         h2("Summary Information"),
                         br(),
                         br(),
                         p("Our dataset includes ", textOutput("num_obs"), " observations that contain 
        values in the favorite team and spread favorite columns. We specifically 
        chose to keep the observations with these variables since we wanted to 
        study the trend of the betting. This turned out to be around ", 
                           textOutput("num_unique_years"), "seasons worth of data with ", 
                           textOutput("num_different_teams"), " different teams. Thus, ignoring the 
        rows without spread data, the smallest spread 
        turned out to be ", textOutput("favorite_min_spread"), " , which which is 
        also considered a 50/50 game or a tossup. Our biggest spread turned out 
        to be ", textOutput("favorite_max_spread"), " which is considered to be a 
        very one sided game. However,our mean turned out to be ", 
                           textOutput("favorite_spread_mean"), " which was much closer to a 50/50
        game than a one sided game. We also found that the proportion of 
        home teams that were favored was ", textOutput("prop_home_favorite"), " 
        and of the home favorites we found the proportion to cover the spread 
        to be ", textOutput("prop_home_favorite_cover") )
                         
                     )
            ),
  )
)



page_two <- tabPanel(
  "Betting Accuracy", 
  style = "margin-top: -20px",
  icon = icon("i", "fa-bullseye"),
  titlePanel("Betting Accuracy"),
  sidebarLayout(
    sidebarPanel(style = "margin-top: 10px", 
                 h4("A key aspect of sports betting is making predictions on who will win 
         the game. In this section, we examine how those predictions stacked up 
         with actual game outcomes."),
                 p("This first plot is intended to show the relationship between the average percent
      accuracy of projected winners actually winning over the seasons. For the 
      first couple years of data, there are not many games recorded which results
      in outliers where the percent accuracy is either 100% or 0%. From the year
      1980 and beyond, we can see a general trend represented with the red trend
      line of a percent accuracy around 60%. This means that for each season,
      where there are multiple games played, the average accuracy of the 
      projected favorite team winning is about 60%. This plot is answering the
      question of whether the accuracy of projected favorites changed for the 
      2020 season due to the COVID 19 pandemic and an adjusted season. In the 
      plot, we can see that there was no significant change in the accuracy of 
      predicting winners, as the point for 2020 percent accuracy lies within the
      expected values represented by the shadow of the trend line."),
                 br(),
                 p("This second plot allows you to choose a team and a season year to see 
        how well bettors are able to predict game outcomes for home games. *Tip: 
        more recent seasons have more data!"),
                 team_input,
                 year_input
    ),
    mainPanel(
      "The Average Percent Accuracy of Projected Favorites by Season",
      plotlyOutput("bets_accuracy_plot"),
      "A Team's Percent Accuracy in a Given Season",
      plotlyOutput("team_season_accuracy")
    )
  )
)

page_three <- tabPanel(
  "Uncertainty in the Over/Under",
  style = "margin-top: -20px",
  icon = icon("i", "fa-question"),
  titlePanel("Uncertainty in the Over/Under"),
  # 
  # fluidRow(
  #   column(1),
  #   column(3,
  #          div(style = "font-size: 10px; padding: 14px; margin-left: 100px; margin-top: 60px"),
  #          spread_slider
  #   ),
  #   column(6,
  #          wellPanel(style = "background-color: #E3E5E7; border-color: #cbcbcb; padding: 4px; width: 800px; height: 410px;",
  #                    plotOutput("spreadyears_plot")
  #          )
  #   )
  # ),
  sidebarLayout(
    sidebarPanel(style = "margin-top: 10px",
      p("In the unprecedented 2020 NFL season, we saw games being played with no fans to mininmal team interaction before the season. This was a season never like before, and it proved to show in the Over/Under lines of games. "),
      div(style="display: inline-block;vertical-align:top; width: 150px;", year_input2), 
      div(style="display: inline-block;vertical-align:top; width: 50px;",HTML("<br>")),
      div(style="display: inline-block;vertical-align:top; width: 150px;", playoff_input)
    ),
    
    mainPanel(style = "margin-top: 10px",
      plotlyOutput("ou_boxplot")
    )
  )
)


page_four <- tabPanel(
  "Interacetive Visuals Part 3",
  style = "margin-top: -20px",
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
  style = "margin-top: -20px",
  icon = icon("i", "fa-check-square"),
  titlePanel("Finishing Thoughts"),
  wellPanel(style = "background: #fff;",
            fluidRow(style = "padding: 30px"),
            h4("Reflections"),
            p("Maddie: I analyzed how the accuracy of projected favorites changed 
              in the 2020 season. In Interactive Visuals Part 1 I explore NFL 
              betting accuracy which has consistently been around 60% accurate 
              for the more recent seasons that we have a complete set of data 
              for where all season's games are reported. Looking specifically at 
              the 2020 season, we can see that here was no significant change in 
              the accuracy of predicting winners, as it is around 63% accurate. 
              Knowing that the 2020 NFL season was shaken up due to the COVID 19
              pandemic, it is suprising that sports bets continue to be 
              relatively accurate."),
            br(),
            h4("After completing this project, we have come up with important 
               insights for people who are interested in betting on NFL games. 
               Using knowledge gained from this project, potential bettors are 
               better equipped to make smart predictions about who will win a 
               game."),
            p("Interested in placing bets? Check out this table showing each 
              team's average score during a home game. This will be helpful to new 
              bettors since for each NFL game the oddsmakers set a number of points
              in which the favorite team is favored by. By making this table it 
              allows the bettors to see the average scores of the favorite home 
              team and either choose for the favored team to win by more than 
              the number of points set, or bet on the underdogs to lose by less 
              than the number of points, it can also work the other way around 
              as well. Therefore by figuring out the favorite team and the 
              average score of the hometeam, it'll give us a better chance of 
              the prediction on how much points that the bettor's team will win 
              or lose by."),
            br(),
            tableOutput("aggragate_table"),
            br(),
            a(href ="https://www.oddsshark.com/nfl/sites", "Click to See Betting Sites"),
            br(),
            img(src = 'ball_money.png', alt = "Football Showered with Money"),
  )
  
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
    tags$div(tags$img(src='nfllogo.png', width = 29, height = 40, style="float:left; margin-left: 5px; margin-right: 10px; margin-top: -10px"), includeCSS("styles.css")), 
    page_one,         
    page_two,
    page_three,
    page_four,
    page_five,
    page_test
  )
)