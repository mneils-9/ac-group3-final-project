# ac-group3-final-project

## Domain: Sports Betting in the NFL
We chose to look at sports betting in the NFL, which is the practice of placing wagers on football players and games. There is a wide range in the level of participation for sports betting: from casual fans to serious money-making fanatics. Regardless of motivations, all sports bets follow three simple steps: selection, stakes, and odds. The most popular types of sports bets are on point spreads and totals, where people often use statistics to decide on their bet and then wait for the game to be played to see the outcome. Betting is always a gamble, and sports betting involves necessary risk. Sports betting often happens online, which is where this project is focusing. We choose this domain because of a shared interest in sports, and curiosity about the world of football betting. This project will examine trends in National Football League (NFL) betting, especially how the COVID 19 pandemic has affected football bets.

## Other Examples of Data Driven Projects in this Domain

This [article](https://www.theringer.com/nfl/2021/1/6/22216167/nfl-playoffs-home-field-advantage-covid-19-restrictions) written by _The Ringer_ uncovered discrepancies in how teams performed this year. By looking at data from games lines, they were able to discover that home teams were less favored this year compared to other years.

This [web application](https://rbsdm.com/stats/stats/), created by [Ben Baldwin](https://twitter.com/benbbaldwin) and [Sebastian Carl](https://twitter.com/mrcaseb), aims to allow people to visualize how well offenses and defenses perform compared to other teams by calculating the _EPA_ (expected points added), a metric that shows the efficiency of a play, per play. We can compare teams by how their offensive/defensive EPA compares to other teams.

This [blog post](https://www.pro-football-reference.com/blog/index7956.html?p=8470) on _pro-football-reference_ explained the formulation of a new index, The Rivers Index, to gauge how efficient quarterbacks play. Similar to the EPA, this metric aims to mainly focus on how well a quarterback plays based on their individual passing statistics.

This [article](https://fivethirtyeight.com/features/the-steelers-and-bills-have-been-historically-lucky-so-far-the-chargers-have-not/) by _fivethirtyeight_ explains which teams overachieved/underachieved using the Pythagorean expectation to compute the expected record of the team, and compare it to their mid-season record.

This [page](https://projects.fivethirtyeight.com/2020-nfl-predictions/) by _fivethirtyeight_ shows their game predictions which are predicted based on their Elo model. This Elo model is formulated by looking at their head-to-head results ([full explanation](https://fivethirtyeight.com/methodology/how-our-nfl-predictions-work/)).

This [data](https://www.kaggle.com/tobycrabtree/nfl-scores-and-betting-data) by _Spreadspoke_ shows National Football League (NFL) game results since 1966 with betting odds information since 1979. People who are into betting in Football can get a better understanding of their own statistical anyalysis and increased their betting outcomes by looking at this dataset.

## Data Driven Questions this Project aims to Answer

- How did having no fans affect home field advantage?

- How did the betting change in the 2020 season?

- Did offenses/defenses benefit from having no fans?

- Which teams benefited most from not having fans?

- How did the pandemic affect player salaries?

## Finding Data

- Attendance dataset 2020 (attendance2020.csv)

  - We were able to download this dataset from pro-football-reference, which is a very reputable source for NFL data.

  - Data is collected by sportradar. This dataset shows the number of fans for each team for all 17 weeks of the 2020 season. These numbers represent the number of scanned tickets at the games.

  - There are 33 rows in the dataset.

  - There are 21 columns in this dataset.

  - It will help us answer if having no fans affected home field advantage and if teams benefited from having no fans.
