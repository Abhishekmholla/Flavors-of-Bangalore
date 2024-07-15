# Uncomment the below lines in order to install the required packages
# install.packages("shiny")
# install.packages("plotly")
# install.packages("wordcloud2")
# install.packages("dplyr")
# install.packages("tidyr")

library(shiny)
library(plotly)
library(wordcloud2)
library(dplyr)
library(tidyr)

# Reading the csv file into a data frame
data <- read.csv("./final_data_cuisine.csv")

# Creating a location and cusine mapping with a new column as parent having location data
location_cusine_mapping <-  data %>% 
  filter(!is.na(dish_liked) & dish_liked != "") %>%
  group_by(location, cuisine_type) %>%
  summarise(popularity = n(), .groups = "drop") %>% ungroup() %>%
  mutate(
    id = paste(location, cuisine_type, sep = "-"),
    label = paste(cuisine_type, "in", location),  
    parent = location
  )

# Adding location as top level parents
location_data <- distinct(location_cusine_mapping, location, .keep_all = TRUE) %>%
  mutate(
    id = location,
    parent = "",
    label = location, 
    popularity = NA  
  )

# Combining to get the full tree map data which will be later used to create the tree map
full_treemap_data <- bind_rows(location_data, location_cusine_mapping)


# Define server logic required to draw a histogram
function(input, output, session) {

    output$distPlot <- renderPlot({

        # generate bins based on input$bins from ui.R
        x    <- faithful[, 2]
        bins <- seq(min(x), max(x), length.out = input$bins + 1)

        # draw the histogram with the specified number of bins
        hist(x, breaks = bins, col = 'darkgray', border = 'white',
             xlab = 'Waiting time to next eruption (in mins)',
             main = 'Histogram of waiting times')

    })

}
