# Title: Shots made by GSW 
# description: This script includes data sets that records the shots attempted by 5 players of GSW, specifically Stpehn Curry. Andre Iguodala, Kevin Durat, Klay Thompson and Daymond Green.
# input(s): The data sets for each player which included columns like shot made, seconds remianing, action type, shot type, shot distance etc.
# output(s): The minute number where a shot occrued and summary of eaach player's shots made.


## redaing data
col_types <- c("character", "character", "integer", "integer", "real", "real", "character","character","character", "real", "character", "real", "real")

curry <- read.csv("../data/stephen-curry.csv", colClasses= col_types, stringsAsFactors = FALSE)
iguodala <- read.csv("../data/andre-iguodala.csv", colClasses= col_types, stringsAsFactors = FALSE)
green <- read.csv("../data/draymond-green.csv", colClasses= col_types, stringsAsFactors = FALSE)
thompson <- read.csv("../data/klay-thompson.csv",colClasses= col_types, stringsAsFactors = FALSE)
durant <- read.csv("../data/kevin-durant.csv", colClasses= col_types, stringsAsFactors = FALSE)

## Adding a column name 
library(dplyr)
curry <- mutate(curry, name = "Stephen Curry")
iguodala <- mutate(iguodala, name = "Andre Iguodala")
green <- mutate(green, name = "Draymond Green")
thompson <- mutate(thompson, name = "Klay Thompson")
durant <- mutate(durant, name = "Kevin Durant")

## Changing original valyes
curry$shot_made_flag[curry$shot_made_flag == 'n'] <- 'shot_no'
curry$shot_made_flag[curry$shot_made_flag == 'y'] <- 'shot_yes'

iguodala$shot_made_flag[iguodala$shot_made_flag == 'n'] <- 'shot_no'
iguodala$shot_made_flag[iguodala$shot_made_flag == 'y'] <- 'shot_yes'

green$shot_made_flag[green$shot_made_flag == 'n'] <- 'shot_no'
green$shot_made_flag[green$shot_made_flag == 'y'] <- 'shot_yes'

thompson$shot_made_flag[thompson$shot_made_flag == 'n'] <- 'shot_no'
thompson$shot_made_flag[thompson$shot_made_flag == 'y'] <- 'shot_yes'

durant$shot_made_flag[durant$shot_made_flag == 'n'] <- 'shot_no'
durant$shot_made_flag[durant$shot_made_flag == 'y'] <- 'shot_yes'


## Adding a column minute
curry <- mutate(curry, minute = curry$period*12 - curry$minutes_remaining)
iguodala <- mutate(iguodala, minute = iguodala$period*12 - iguodala$minutes_remaining)
green <- mutate(green, minute = green$period*12 - green$minutes_remaining)
thompson <- mutate(thompson, minute = thompson$period*12 - thompson$minutes_remaining)
durant <- mutate(durant, minute = durant$period*12 - durant$minutes_remaining)

 
# sink summary
sink(file = '../output/stephen-curry-summary.txt')
summary(curry)
sink()

sink(file = '../output/andre-iguodala-summary.txt')
summary(iguodala)
sink()

sink(file = '../output/draymond-green-summary.txt')
summary(green)
sink()

sink(file = '../output/klay-thompson-summary.txt')
summary(thompson)
sink()

sink(file = '../output/kevin-durant-summary.txt')
summary(durant)
sink()

#Stack the tables into one single data frame
tables <- rbind(curry, iguodala, green, thompson, durant)

# Export table as a CSV file 
write.csv(
  x = tables,
  file = '../data/shots-data.csv'
)

#sink summary of tables
sink(file = '../output/shots-data-summary.txt')
summary(tables)
sink()

