#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinyjs)
library(ggplot2)
library(plotly)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    
    
    # reading the data
    covData <- read.csv("2019_nCoV_data.csv")
    covData$Date <- as.Date(covData$Date, "%m/%d/%Y")
    
    covByDate <- covData %>% group_by(Date) %>% summarise(Confirmed = sum(Confirmed), Deaths = sum(Deaths), Recovered = sum(Recovered))
    
    numberOfDays <- nrow(covByDate)
    covByDate$DayNum <- 1:numberOfDays
    
    xname="Confirmed"
    covByDate$PlotData <- covByDate$Confirmed

    output$distPlot <- renderPlotly({
                
            daysInput <- input$sliderDayNum
            totalDays <- numberOfDays+daysInput
            
            if(input$eventCat == 2){
                    covByDate$PlotData <- covByDate$Deaths
                    xname="Deaths"
            }
            else if (input$eventCat == 3){
                    covByDate$PlotData <- covByDate$Recovered
                    xname="Recovered"
            }
            
            model <- lm(PlotData ~ poly(DayNum, degree = 2, raw=T), data = covByDate)
            modelPred <- predict(model, data.frame(DayNum=1:totalDays))

            p <- plot_ly(x = ~covByDate$Date, y = ~covByDate$PlotData, type = 'scatter',  
                         name=xname, marker = list(color = 'red', size=10)) %>%
            layout(title = 'Number of Wuhan coronavirus cases by date',
                        xaxis = list(title = "Date"),
                        yaxis = list(side = 'left', title = 'Number of cases', showgrid = FALSE))
            if(input$showModel){
                    modellines <- data.frame(
                            Date = seq(min(covByDate$Date), by=1, len=totalDays), 
                            PlotData = modelPred)
                    p <- p %>% add_trace(x = ~modellines$Date, y = ~modellines$PlotData,  mode = "lines", 
                              marker = list(color = 'blue', size=5), name="Predicted cases") 
            }
            p
    
    })
  
})
