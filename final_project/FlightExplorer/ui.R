#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Flight Cancellation and Delay Explorer"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
        uiOutput("airlines"),
        textInput("FL_NUM", "Flight Number:"),
        uiOutput("month"),
        uiOutput("cities"),
        uiOutput("button")
        #submitButton("submit")
       
       
    ),
    # Show a plot of the generated distribution
    mainPanel(
            h3("Hello"),
            textOutput("msg"),
            plotOutput('plot'),
            dataTableOutput('data')
                        
        
))))
