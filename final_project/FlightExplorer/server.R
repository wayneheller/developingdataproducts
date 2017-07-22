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
  
  dfFlightSummary <- read.csv("FlightSummaryData.csv")
        
  output$airlines <- renderUI({selectInput("choose_airline", "Airline:", as.list(unique(dfFlightSummary$AIRLINE_NAME)))})
  
  
  
        output$cities <- renderUI({
                if (!is.null(input$choose_airline) & input$FL_NUM >=1 ) {
                        dfFlightSummary <- dfFlightSummary %>% filter(AIRLINE_NAME == input$choose_airline, FL_NUM == input$FL_NUM)
                        selectInput("choose_origin", "Origination City:", as.list(unique(dfFlightSummary$ORIGIN_CITY_NAME)))
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
                                      "December" = 12), selected = ifelse(is.null(input$choose_month) | length(input$choose_month) == 0, 1, input$choose_month))
                        }
                })
        output$data <- renderDataTable({
                if (!is.null(input$choose_month) & !is.null(input$choose_origin)  ) {
                        #dfFlightSummary %>% filter(MONTH == input$choose_month, ORIGIN_CITY_NAME == input$choose_city)
                        dfFlightSummary %>% filter(MONTH == input$choose_month, AIRLINE_NAME == input$choose_airline, FL_NUM == input$FL_NUM, ORIGIN_CITY_NAME == input$choose_origin)
                }
        })
        output$plot <- renderPlot({
                if (!is.null(input$choose_month) & !is.null(input$choose_origin)  ) {
                        #dfFlightSummary %>% filter(MONTH == input$choose_month, ORIGIN_CITY_NAME == input$choose_city)
                        dfPlot <- dfFlightSummary %>% filter(MONTH == input$choose_month, AIRLINE_NAME == input$choose_airline, FL_NUM == input$FL_NUM, ORIGIN_CITY_NAME == input$choose_origin)
                        g <- ggplot(dfPlot, aes(DAY_OF_WEEK, avg_delay))
                        # Number of cars in each class:
                        g + geom_bar(stat="identity")
                        #barplot(as.matrix(dfPlot[, c("DAY_OF_WEEK", "avg_delay")]))
                        }
        })
        #output$button <- renderUI({submitButton("Next >")})
        
  
  
  #if (input$MONTH >= 1 & input$choose_origin != "") {
  #      output$data = renderDataTable({dfFlightSummary %>% filter(MONTH == input$MONTH, DAY_OF_WEEK== input$DAY_OF_WEEK, FL_NUM == input$FL_NUM)
  #      })
  
  #}
  
})
