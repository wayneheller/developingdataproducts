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
        h4("Instructions:"),
        h5("Step 0: Be Patient While Data Loads."),
        p("You should see a progress message in the lower right corner.  If not, you may need to reload this page."),
        h5("Step 1: Select Airlines."),
        h5("Step 2: Select Flight Number."),
        h5("Step 3: Select Month of Departure."),
        p("1 = January, 2 = February, and so on"),
        h5("Step 4: Select City of Origination."),
        uiOutput("airlines"),
        uiOutput("flight"),
        uiOutput("month"),
        uiOutput("cities"),
        uiOutput("button")
        #,submitButton("submit")
       
       
    ),
    # Show a plot of the generated distribution
    mainPanel(
            plotOutput('plot1'),
            plotOutput('plot2'),
            dataTableOutput('data')
                        
        
))))
