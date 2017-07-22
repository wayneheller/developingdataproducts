#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(dplyr)
library(ggplot2)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    withProgress(message = "Loading Flight Data...Please Wait",  {
        dfFlightSummary <- read.csv("FlightSummaryData.csv")
    } )
        output$airlines <- renderUI({selectInput("choose_airline", "Airline:", as.list(unique(dfFlightSummary$AIRLINE_NAME)), selected = NULL)})
  
        output$flight <- renderUI({
                if (!is.null(input$choose_airline)) {
                        dfFlightSummary <- dfFlightSummary %>% filter(AIRLINE_NAME == input$choose_airline)
                        selectInput("FL_NUM", "Flight Number:", as.list(sort(unique(dfFlightSummary$FL_NUM))))
                }
                else {selectInput("FL_NUM", "Flight Number:", "First Select Airlines")
                }
                
        })
    
  
        output$cities <- renderUI({
                if (!is.null(input$choose_airline) & !is.null(input$choose_month) & input$FL_NUM >=1 ) {
                        dfFlightSummary <- dfFlightSummary %>% filter(AIRLINE_NAME == input$choose_airline, FL_NUM == input$FL_NUM, MONTH == input$choose_month)
                        selectInput("choose_origin", "Origination City:", as.list(unique(dfFlightSummary$ORIGIN_CITY_NAME)))
                }
                else {selectInput("choose_origin", "Origination City:",
                                  c("First Select Airlines, Enter Flight Number and Select Month"))
                        
                }
                })
        output$month <- renderUI({
                if (!is.null(input$choose_airline) & input$FL_NUM >=1 ) {
                        #dfFlightSummary <- dfFlightSummary %>% filter(AIRLINE_NAME == input$choose_airline, FL_NUM == input$FL_NUM)
                        selectInput("choose_month", "Month of Departure:",
                                    c("January" = 1,
                                      "February" = 2,
                                      "March" = 3,
                                      "April" = 4,
                                      "May" = 5,
                                      "June" = 6,
                                      "July" = 7,
                                      "August" = 8,
                                      "September" = 9,
                                      "October" = 10,
                                      "November" = 11,
                                      "December" = 12))
                }
                else {selectInput("choose_month", "Month of Departure:",
                                  c("First Select Airlines and Enter Flight Number"))
                        
                }
                })
        output$data <- renderDataTable({
               if (!is.null(input$choose_month) & !is.null(input$choose_origin)  ) {
        #                #dfFlightSummary %>% filter(MONTH == input$choose_month, ORIGIN_CITY_NAME == input$choose_city)
                       dfFlightSummary %>% filter(MONTH == input$choose_month, AIRLINE_NAME == input$choose_airline, FL_NUM == input$FL_NUM, ORIGIN_CITY_NAME == input$choose_origin)
               }
        })
        output$plot1 <- renderPlot({
                if (!is.null(input$choose_month) & !is.null(input$choose_origin)  ) {
                        #dfFlightSummary %>% filter(MONTH == input$choose_month, AIRLINE_NAME == input$choose_airline, FL_NUM == input$FL_NUM, ORIGIN_CITY_NAME == input$choose_origin)
                        dfPlot <- dfFlightSummary %>% filter(MONTH == input$choose_month, AIRLINE_NAME == input$choose_airline, FL_NUM == input$FL_NUM, ORIGIN_CITY_NAME == input$choose_origin)
                        day.of.week <- c("Monday" = 1, "Tuesday" =2, "Wednesday"=3, "Thursday"=4,"Friday"=5,"Saturday"=6,"Sunday"=7)
                        g <- ggplot(dfPlot, aes(reorder(names(day.of.week[DAY_OF_WEEK]), DAY_OF_WEEK) , avg_delay))
                        g <- g + labs(title = "Average Minutes of Arrival Delay by Day of the Week", x = "Day of Week", y= "Average Arrival Delay (mins)")
                        # Number of cars in each class:
                        g <- g + geom_bar(stat="identity", color="black", fill="red")
                        g + geom_text(aes(label=avg_delay), vjust=1.5, colour="black")
                        #barplot(as.matrix(dfPlot[, c("DAY_OF_WEEK", "avg_delay")]))
                        }
        })
        output$plot2 <- renderPlot({
                if (!is.null(input$choose_month) & !is.null(input$choose_origin)  ) {
                        #dfFlightSummary %>% filter(MONTH == input$choose_month, ORIGIN_CITY_NAME == input$choose_city)
                        dfPlot <- dfFlightSummary %>% filter(MONTH == input$choose_month, AIRLINE_NAME == input$choose_airline, FL_NUM == input$FL_NUM, ORIGIN_CITY_NAME == input$choose_origin)
                        day.of.week <- c("Monday" = 1, "Tuesday" =2, "Wednesday"=3, "Thursday"=4,"Friday"=5,"Saturday"=6,"Sunday"=7)
                        g <- ggplot(dfPlot, aes(reorder(names(day.of.week[DAY_OF_WEEK]), DAY_OF_WEEK) , pct_cancelled))
                        g <- g + labs(title = "Percent Flights Cancelled by Day of the Week", x = "Day of Week", y= "% Flights Cancelled")
                        # Number of cars in each class:
                        g <- g+ geom_bar(stat="identity", color="red", fill="red") + ylim(0,100)
                        g + geom_text(aes(label=pct_cancelled), vjust=1.5, colour="black")
                        
                }
        })
        
  
  

  
})
