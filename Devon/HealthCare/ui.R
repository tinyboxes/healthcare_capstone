library(shiny)
library(tidyverse)
library(shinydashboard)
library(DT)
##Establish that this is a dashboard page
dashboardPage(
  dashboardHeader(title = "HealthCare"), ##Naming the entire page
  ##Creating The Tabs that Will Be Found in the Body
  dashboardSidebar(
    sidebarMenu(
      menuItem("About", ##What Users Will See
               tabName = "about", ##What coders will see
               icon = icon("book")), ##What the icon on the page will be
      menuItem("Background Research",
               tabName = "background",
               icon = icon("book")),
      menuItem("EDA",
               tabName = "eda",
               icon = icon("book")),
      menuItem("Results",
               tabName = "results",
               icon = icon("book")),
      menuItem("Prediction Visuals",
               tabName = "predictvis",
               icon = icon("book")),
      menuItem("Patient Table",
               tabName = "patients",
               icon = icon("book")),
      menuItem("Cost Modeling/Improvements",
               tabName = "cost",
               icon = icon("book"))
    )
  ),
  ##Creating The Body of the Page
  dashboardBody(tabItems( ##Establishing That I want to work on the tab items
    tabItem("about", ##Calling the tab I wish to work on
            print("This where we will talk about the project")), ##What will go inside the tab
    tabItem("background",
            print("This is where we will put Tim/Adrian's thoughts for their background research"),
            br(),
            print("Talk about the dataset"),
            br(),
            print("talk about the paper")),
    tabItem("eda",
            tabBox(id = "edatabs",width = 12,
                   tabPanel(title = "Outcome",
                            print("Stuff 1")),
                   tabPanel(title = "Age Groups",
                            print("Stuff 2"))),
            print("EDA graphs, tabs?")),
    tabItem("results",
            tabBox(id = "resultstabs",width = 6,
                   tabPanel(title = "ROC Curve",
                            print("Have a graph of the ROC curve and the AUC")),
                   tabPanel(title = "Definitions",
                            print("Define specificity, fpc, etc."))),
            print("Include Confusion matrix, specificifty, fp rate, tabs for roc curve, definitions?")),
    tabItem("predictvis",
            tabBox(id = "predicttabs",width = 6,
                   tabPanel(title = "Variagle Inportance",
                            print("Show a variable importance graph")),
                   tabPanel(title = "User Options",
                            print("Put drop-down tabs for users to chose"))),
            print("One pie chart, bar chart, tabs for variable importance, options")),
    tabItem("patients",
            tabBox(id = "predicttabs",width = 6,
                   tabPanel(title = "Patient Demographics",
                            print("Patient ID, age, race, gender")),
                   tabPanel(title = "Test Results",
                            print("Test values"))),
            print("Have a clickable table, tabs for patient information")),
    tabItem("cost",
            print("Back to Adrian/Tim for their cost information"))
    
  )) 
)