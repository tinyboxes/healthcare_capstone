
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
            box(h1('Predicting Hospital Readmission',align='center'),background='light-blue',width=24),
            box(background='purple', width=24,
                p('about'),
                p('about'),
                p('about'))
                
              
            ), ##What will go inside the tab
    tabItem("background",
            box(h1('Background Research1',align='center'),background='light-blue',width=24),
            box(background='purple', width=24,
                p('about'),
                p('about'),
                p('about')
            ),
            box(h1('Background Research2',align='center'),background='light-blue',width=24),
            box(background='purple', width=24,
                p('about'),
                p('about'),
                p('about')
            )
    ),
    tabItem("eda",
            tabBox(id = "edatabs",width = 12,
                   tabPanel(title = "Outcome",
                            print("Stuff 1")),
                   tabPanel(title = "A1C level",
                            print("Stuff 2")),
                   tabPanel(title = "Diagnoses",
                            print("Stuff 3")),
                   
                   tabPanel(title = "Days in hospital",
                            fluidRow(box(width = 12,
                            plotOutput("days_hospital_hist")
                            )
                            )),
                   
                   tabPanel(title = "Num of labs",
                            fluidRow(box(width = 12,
                              plotOutput("num_lab_hist")
                            )
                            )),
                   
                   tabPanel(title = "Num of meds",
                            fluidRow(box(width = 12,
                              plotOutput("num_meds_hist")
                            )
                            )),
                   tabPanel(title = "Age Groups",
                            print("Stuff 7")),
                   tabPanel(title = "Metfomin&Insulin",
                            print("Stuff 8")),
                   tabPanel(title = "Race",
                            print("Stuff 9")))
            ),
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
    tabItem("patients",fluidRow(column(7, dataTableOutput("table")),
            column(5,tabBox(id = "predicttabs",width = 12,
                   tabPanel(title = "Patient Demographics",
                            h4("Prediction:"),
                            textOutput("dp_c"),
                            h4("Encounter ID:"),
                            textOutput("de_i"),
                            h4("Patient Number:"),
                            textOutput("dp_n"),
                            h4("Age Bracket:"),
                            textOutput("d_a"),
                            h4("Race:"),
                            textOutput("d_r"),
                            h4("Gender:"),
                            textOutput("d_g")),
                   tabPanel(title = "Aministrative Information",
                            print("WOOT")),
                   tabPanel(title = "Test Results",
                            print("Test values"))))),
            print("Have a clickable table, tabs for patient information")),
    tabItem("cost",
            print("Back to Adrian/Tim for their cost information"))
    
  )) 
)