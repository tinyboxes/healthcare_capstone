#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
   
  output$distPlot <- renderPlot({
    
    # generate bins based on input$bins from ui.R
    x    <- faithful[, 2] 
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    
    # draw the histogram with the specified number of bins
    hist(x, breaks = bins, col = 'darkgray', border = 'white')
    
  })
  
  #outcome-EDA  
  output$outcome<- renderPlotly({
    outcome
  })
  
  #A1C-EDA 
  output$A1C<- renderPlotly({
    A1C
  })
  
  #diagnoses-EDA
  output$diagnoses<- renderPlotly({
    diagnoses
  })

  #days in hospital-EDA  
  output$days_hospital_hist<- renderPlotly({
    days_hospital
  })
  
  # num of lab-EDA
  output$num_lab_hist<- renderPlotly({
    num_lab
  })
  
  # num of lab-EDA
  output$num_meds_hist<- renderPlotly({
    num_meds
  })
  
  # age-EDA
  output$age_hist<- renderPlotly({
    age
  })
  
  #metformin-EDA
  output$metformin_hist<- renderPlotly({
    metformin
  })
  
  #insulin-EDA
  output$insulin_hist<- renderPlotly({
    insulin
  })
  
  #race-EDA
  output$race_hist<- renderPlotly({
    race
  })
  
})
