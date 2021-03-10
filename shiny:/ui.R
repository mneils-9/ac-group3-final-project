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

scores_df <- read.csv("data:/scoresspread.csv")

team_input <- selectInput(
  inputId = "team_input",
  choices = sort(unique(scores_df$team_home)),
  label = "Select Team"
)

week_input <- selectInput(
  inputId = "week_input",
  choices = mixedsort(unique(scores_df$schedule_week)),
  label = "Week",
  multiple = TRUE
)

year_input <- selectInput(
  inputId = "year_input",
  choices = sort(unique(scores_df$schedule_season)),
  label = "Season"
)

year_input2 <- selectInput(
  inputId = "year_input2",
  choices = scores_df %>% filter(schedule_season > 1978) %>% select(schedule_season) %>% unique() %>% arrange() %>% map_df(rev),
  label = "Season"
)

playoff_input <- prettyRadioButtons(
  inputId = "playoff_input",
  choices = list("True" = TRUE, "False" = FALSE),
  selected = FALSE,
  label = "Include Playoffs",
  animation = "smooth",
  shape = "curve",
  inline = TRUE
)

trend_input <- selectInput(
  inputId = "trend_input",
  choices = c("Overall O/U Line", "Overall Total Points", "Season O/U Line", "Season Total Points"),
  multiple = TRUE,
  label = "Include Trend Line",
)

opacitybp_input <- sliderInput(
  inputId = "opacitybp_input",
  min = 0,
  max = 1.0,
  value = 0.1,
  step = 0.01,
  label = "Boxplot Opacity",
)

# Introduction Page
page_one <- tabPanel(
  "Introduction", 
  style = "margin-top: -20px",
  icon = icon("i", "fa-info-circle"),
  titlePanel("Introduction"),
  wellPanel(style = "margin-top: 21px",
            fluidRow(style = "padding: 30px; margin-top: -20px; margin-bottom: -20px", tags$head(tags$style("#container * { display: inline; }")),
                     div(id="container",
                         h3("Domain"),
                         br(),
                         br(),
                         p("We chose to look at sports betting in the NFL, which is the practice of placing wagers on football players and games. There is a wide range in the level of participation for sports betting: from casual fans to serious money-making fanatics. Regardless of motivations, all sports bets follow three simple steps: selection, stakes, and odds. The most popular types of sports bets are on point spreads and totals, where people often use statistics to decide on their bet and then wait for the game to be played to see the outcome. Betting is always a gamble, and sports betting involves necessary risk. Sports betting often happens online, which is where this project is focusing. We choose this domain because of a shared interest in sports, and curiosity about the world of football betting. This project will examine trends in National Football League (NFL) betting, especially how the COVID 19 pandemic has affected  football betting and team play."),
                         br(),
                         br(),
                         br(),
                         img(src = 'betting_infographic.PNG', alt = "US sports betting infographic", height="60%", width="60%", style = "display: block; margin-left: auto; margin-right: auto;"),
                         tags$div(style = "text-align: center; font-size: 10px; display: block;", tags$em("This infographic, ", tags$a(href="https://www.economist.com/graphic-detail/2019/12/29/as-much-as-26bn-could-be-gambled-on-american-sport-in-2020", "by the Economist"), ", shows which states have legalized sports gambling on the map and the bar chart on the side shows the rapid growth of legal sports bets in the last few years.")),
                         br(),
                         br(),
                         h3("Key Terms"),
                         br(),
                         br(),
                         p(strong("Spread"), "- the expected point margin by which a team will win or lose by. In other words, how much a team is favored by. A ", 
                           em("negative"), " spread implies the team is favored by that amount. A ",
                           em("positive")," spread implies the team is the underdog by that amount." ),
                         br(),
                         p(strong("Cover the spread"), "- the underdog/favored team was able to win/lose by the certain threshold. An underdog team can either lose by the number of points set in the spread or less and cover the spread. In other words, the underdog is given a handicap. Moreover, the favored team ",
                           em("has"), " to win by the given spread or they will not cover the spread."),
                         br(),
                         p(strong("Over Under"), "- the expected total number of points scored by both teams in the given game. People can either bet on the over (going to go over the expected total) or the under (going under the expected total)."),
                         br(),
                         br(),
                         p(em("E.g."), "the super bowl between the Chiefs and the Buccaneers this year (Super Bowl 55), had a spread of Chiefs -3.5 and an over/under of 57.7. This means that the Chiefs were favored by 3.5 points, and they had to win by 3.5 points or else they wouldn't cover the spread. The Buccaneers on the other hand, could lose by less than 3.5 points or just win to cover the spread. The Buccaneers came out on top 31-9, so Chiefs didn't cover and the game went under since the total points scored was under 57.7."),
                         br(),
                         br(),
                         h3("Summary Information"),
                         br(),
                         br(),
                         p("Our dataset includes ", textOutput("num_obs"), " observations that contain values in the favorite team and spread favorite columns. We specifically chose to keep the observations with these variables since we wanted to study the trend of the betting. This turned out to be around ", 
                           textOutput("num_unique_years"), "seasons worth of data with ", 
                           textOutput("num_different_teams"), " different teams. Thus, ignoring the rows without spread data, the smallest spread turned out to be ", textOutput("favorite_min_spread"), " , which which is also considered a 50/50 game or a tossup. Our biggest spread turned out to be ", textOutput("favorite_max_spread"), " which is considered to be a very one sided game. However,our mean turned out to be ", textOutput("favorite_spread_mean"), " which was much closer to a 50/50 game than a one sided game. We also found that the proportion of home teams that were favored was ", textOutput("prop_home_favorite"), " and of the home favorites we found the proportion to cover the spread to be ", textOutput("prop_home_favorite_cover") )
                         
                     )
            ),
  )
)

# Betting Accuracy Page
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
      wellPanel(style = "margin-top: 10px; padding: 6px",
                "The Average Percent Accuracy of Projected Favorites by Season",
                plotlyOutput("bets_accuracy_plot")
                
      ),
      wellPanel(style = "margin-top: 10px; padding: 6px",
                "A Team's Percent Accuracy in a Given Season",
                plotlyOutput("team_season_accuracy")
      )
    )
  )
)

# Uncertainty in the Over/Under Lines Page
page_three <- tabPanel(
  "Uncertainty in the Over/Under Lines",
  style = "margin-top: -20px",
  icon = icon("i", "fa-question"),
  titlePanel("Uncertainty in the Over/Under Lines"),
  sidebarLayout(
    sidebarPanel(style = "margin-top: 10px",
                 h4("Though the spread of games can tell us the uncertainy and favorites of games, Over/Under lines can tell us more about what the odd makers are seeing."),
                 p("In the unprecedented 2020 NFL season, we saw games being played with no fans to minimal team interaction before the season. This was a season never like before, and it proved to show in the Over/Under lines of games. In this plot, we are able to observe the distribution of the Over/Under lines of each week throughout the given season. In addition, we are able to compare the overall averages of Over/Under lines and total points scored, and the season averages. I included this to show how the trends might differ or be similar."),
                 br(),
                 div(style="display: inline-block;vertical-align:top; width: 150px;", year_input2), 
                 div(style="display: inline-block;vertical-align:top; width: 50px;",HTML("<br>")),
                 div(style="display: inline-block;vertical-align:top; width: 150px;", playoff_input),
                 trend_input,   chooseSliderSkin(
                   skin = "Flat",
                   color = "#1C2833"
                 ), opacitybp_input
    ),
    
    mainPanel(style = "margin-top: 10px",
              wellPanel(style = "padding: 6px",
                        "Distribution of Over/Under Lines for Every Week of the Season",
                        plotlyOutput("ou_boxplot")
              ),
              
              wellPanel(
                "We are able to see that in many cases the set Over/Under Lines was much lower compared to the total points scored. However, it is a common trend that oddsmakers increase the line as we see total points scored increase. Especially in the 2020 season, we can see that the average total scored points appears to be higher than the Over/Under Line for the first couple of weeks. It dipped for a bit after that but took a bit of a bounce-back after week 10. Overall, we do see that points are being scored at an increasing rate, causing the Over/Under Lines to go up as well. For the past decade or so, we have seen the average total points scored deviate away from the average calculated across all seasons."
              )
    )
  )
)

page_four <- tabPanel(
  "Weeks & Seasons Average Spread",
  style = "margin-top: -20px",
  icon = icon("i", "fa-arrows-alt-h"),
  titlePanel("Weeks & Seasons Average Spread"),
  
  sidebarLayout(
    sidebarPanel(style = "margin-top: 10px", week_input,
                 p("As we mentioned on an introduction page, spread is  the expected 
                   point margin by which a team will win or lose by. Point spread bets
                   are a popular type of sports bet that you can make. Point spread bets
                   is also mostly likely to be a big part of your winning betting strategy.
                   Matter of fact, many successful professional sports bettors use the point spread
                   bets stategy to make up their winning stategy. As the world was hit with COVID 19,
                   I wanted to see if it would affect the average spread in the NFL sport betting at all.
                   It turns out out that COVID 19 does not affect the average spread. However, You can still 
                   utilize this plot by studying the trend of the spread and once you can pin out the pattern,
                   you'll have a higher chance of spotting out the value and pick out the winners by 
                   the amount point spread more confidently."), 
                 
                 
                 
    ),
    mainPanel(style = "margin-top: 10px",
              wellPanel(style = "padding: 6px",
                        plotlyOutput("week_spreadplot")
              )
    )
  )
)

page_five <- tabPanel(
  "Finishing Thoughts",
  style = "margin-top: -20px",
  icon = icon("i", "fa-check-square"),
  titlePanel("Finishing Thoughts"),
  wellPanel(style = "margin-top: 21px",
            h4("After completing this project, we have come up with important 
               insights for people who are interested in betting on NFL games. 
               Using knowledge gained from this project, potential bettors are 
               better equipped to make smart predictions about who will win a 
               game. Especially with the 2020 season behind us, line makers now have data from a season under a pandemic they can use to alter the lines. All in all, the pandemic resulted in uncertainty before the start of the season, but that uncertainty chipped away as the season progressed.", em("(Hover over each title to get each of our reflections.)"))
  ),
  fluidRow(
    column(4,
           tags$div(HTML(
             "<div class=flip-card>
              <div class=flip-card-inner>
                <div class=flip-card-front>
                  <h2 style=text-align:center;vertical-align:middle>Betting Accuracy</h2> 
                </div>
                <div class=flip-card-back>
                  <i style=text-align:center>Maddie: I analyzed how the accuracy of projected favorites changed 
                          in the 2020 season. I explore NFL 
                          betting accuracy which has consistently been around 60% accurate 
                          for the more recent seasons that we have a complete set of data 
                          for where all season's games are reported. Looking specifically at 
                          the 2020 season, we can see that here was no significant change in 
                          the accuracy of predicting winners, as it is around 63% accurate. 
                          Knowing that the 2020 NFL season was shaken up due to the COVID 19
                          pandemic, it is suprising that sports bets continue to be 
                          relatively accurate.</i>
                </div>
              </div>
            </div>"
           ))),
    column(4,
           tags$div(HTML(
             "<div class=flip-card>
              <div class=flip-card-inner>
                <div class=flip-card-front>
                  <h2 style=text-align:center>Uncertainty in the Over/Under Lines</h2> 
                </div>
                <div class=flip-card-back>
                  <i style=text-align:center; padding:30px>Kobe: It was interesting to see how the Over/Under lines differed amongst different seasons. But overall, we've seen a trend up in offensive scoring, causing the Over/Under lines to increase proportionally. However, we saw odds makers didn't take into account more factors to why offenses would start scoring more in the 2020 season as we saw totals going way over the line in the first few weeks. Odd makers definitely had a very tough time making lines in this unprecedented season. Though I think they will have much better lines for the 2021 season as they were able to collect data for one season through a pandemic. Overall, we observed a trend of uncertainty before the start of the season, as Over/Under Lines and total scored points in the first few weeks of 2020 had wide margins compared to the other seasons.</i>
                </div>
              </div>
            </div>"
           ))),
    column(4,
           tags$div(HTML(
             "<div class=flip-card>
              <div class=flip-card-inner>
                <div class=flip-card-front>
                  <h2>Weeks & Seasons Average Spread</h2> 
                </div>
                <div class=flip-card-back>
                  <i>Bryan: I analyzed how Covid 19 would affect the average spread.
              In interactive Visuals part 3, I explore the changes in average spread
              per week of each NFL seasons. From analyzing the trend of average of all the
              seasons before 2020 and comparing it with the 2020 NFL season,
              I see that there was no correlation between Covid 19 and the average spread.
              The average spread still moved in a normal trend. From what I see, 
              the average spread from week 1 to week 18 from the year 2015 to 2020. The spread
              average never exceed or fall by 1.5 points each following year which was unique and cool to see. </i>
                </div>
              </div>
            </div>"
           )))
  ),
  
  br(),
  
  fluidRow(
    column(5,
           wellPanel(
             dataTableOutput("aggragate_table")
           )
    ),
    column(5,
           wellPanel(style = "width: 790px",
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
              or lose by.", em("Click on the image below to get a list of betting sites available.")),
                     
           ),
           
           wellPanel(style = "width: 790px; height: 320px; padding: 6px",
                     a(href ="https://www.oddsshark.com/nfl/sites", img(src = 'ball_money.png', alt = "Football Showered with Money", style = "width: 775px; height: 305px;"), style = "text-align: center; font-size: 10px; display: block;")
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
    page_five
  )
)