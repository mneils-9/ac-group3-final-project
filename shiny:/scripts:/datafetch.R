library(rvest)

tbl_final <- data.frame()

for (year in 1994:2020) {
  url <- sprintf("https://www.pro-football-reference.com/years/%s/penalties.htm", year)
  
  webpage <- read_html(url)
  
  tbls_ls <- webpage %>%
    html_nodes("table") %>%
    .[1] %>%
    html_table(fill = TRUE)
  
  tbl <- tbls_ls[[1]]
  
  tbl <- mutate(tbl, year = year)
  
  tbl_final <- rbind(tbl_final, tbl)
}

write.csv(tbl_final, "../data:/penaltiesfull.csv")