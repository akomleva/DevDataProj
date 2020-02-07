#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(plotly)


# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Coronavirus data. Explore and forecast"),
  
  # Select bar, slider and button 
  sidebarLayout(
          sidebarPanel(
                  helpText("Choose event category: Confirmed cases, Deaths, Recovered"),
                  selectInput("eventCat",
                              "Show cases:",
                              c("Confirmed" = 1,
                                "Deaths" = 2,
                                "Recovered" = 3)),
                  helpText("Choose whether or not you'd like to see a prediction and choose the number of days to predict"),
                  checkboxInput("showModel", "Show/Hide Prediction", value = TRUE),
                  sliderInput("sliderDayNum", "Number of days for the forecast", 1, 10, value = 5),
                  submitButton("Submit")
          ),
          
          # Show a plot of the generated distribution
          mainPanel(
                  textOutput(""),
                  p(),
                  plotlyOutput("distPlot")
                  
          )
  )
          
  
))
