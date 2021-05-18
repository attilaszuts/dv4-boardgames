library(data.table)
library(tidyverse)
df <- data.table(read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-03-12/board_games.csv"))

df <- df[, .(name, max_players, min_players, min_playtime, playing_time, max_playtime,
             min_age, year_published, category, 
             family, mechanic, publisher, average_rating, users_rated)]

param_min_player <- min(unique(df$min_players))
param_max_player <- max(unique(df$max_players[df$max_players < 100]))

param_max_playtime <- max(df$max_playtime)

# get the categories in the data
categories_list <- lapply(as.character(df$category), strsplit, ',')
cats <- c()
for (e in categories_list) {
  for (i in e[[1]]) {
    cats <- c(cats, i)
  }
}
cats <- sort(unique(cats))


# filtering the results
is_cat <- function(dfcol, category) {
  # split a cell and check if any of the split values are in a category vector
  # return the number of matches
  bool_vec <- category %in% strsplit(dfcol[1], ',')[[1]]
  return(sum(bool_vec))
}
filter_exact_match <- function(df, dfcol, category_inputs) {
  # filter a df by creating a numeric x vector that contains for each row, 
  # how many matches they have in category inputs
  # keep the rows that have exacltly that many matches as categories supplied
  x <- as.numeric(sapply(dfcol, function(x) is_cat(x, category_inputs)))
  filtered_df <- df[x == length(category_inputs)]
  return(filtered_df)
}
filter_df <- function(df, inputs) {
  # filter a df based on a list of parameters
  if (inputs$play_time == 0) {
    df_display <- df[min_players >= inputs$min_player &
                       max_players <= inputs$max_player &
                       min_age >= inputs$min_age &
                       year_published >= as.numeric(format(inputs$year[1], "%Y")) &
                       year_published <= as.numeric(format(inputs$year[2], "%Y")) &
                       average_rating >= inputs$rating / 10,]
  } else {
    df_display <- df[min_players >= inputs$min_player &
                       max_players <= inputs$max_player &
                       min_playtime >= inputs$play_time &
                       max_playtime <= inputs$play_time &
                       min_age >= inputs$min_age &
                       year_published >= as.numeric(format(inputs$year[1], "%Y")) &
                       year_published <= as.numeric(format(inputs$year[2], "%Y")) &
                       average_rating >= inputs$rating / 10,]
  }
  df_display[, playtime := ifelse(min_playtime == max_playtime, min_playtime, paste(min_playtime, max_playtime, sep = "-"))]
  df_display[, players := ifelse(min_players == max_players, min_players, paste(min_players, max_players, sep = "-"))]
  df_display <- filter_exact_match(df_display, df_display$category, inputs$categories)
  
  old_names <- c("name", "max_players", "min_players", "players", "min_playtime", "playing_time", 
                 "playtime", "max_playtime", "min_age", "year_published", "category",
                 "family", "mechanic", "publisher", "average_rating", "users_rated")
  
  new_names <- c("Name", "max_players", "min_players", "Number of players", "min_playtime",
                 "playing_time", "Play time (m)", "max_playtime", "Minimum age", "Publication year", 
                 "Category", "family", "Mechanic", "publisher", "Average rating", "Number of users rated")
  for (i in 1:length(old_names)) {
    setnames(df_display, old_names[i], new_names[i], skip_absent = T)
  }
  df_display <- df_display[, setdiff(new_names, old_names), with = F]
  return(df_display)
}


