
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
            box(h1('Predicting Hospital Readmission',align='center'),background='purple',width=24),
            box(background='light-blue', width=24,
                h3('About the Company'),
                p('Argos Health maximizes claim reimbursement for hospitals, 
                  health systems and physician groups by billing & resolving complex claims.'),
                br(),
                h3('Project Rationale'),
                p('The purpose of this project is to develop a predictive model which will help hospitals 
                  reduce their readmission rates among diabetic patients.'),
                p('The hospital has a new 2019 goal of reducing hospital readmission rates. Both the hospital finance and clinical 
                   care teams are interested in how the data science team may help these departments reach this goal.'),
                br(),
                h3('Technical Approach'),
                p('Develop a model which predicts whether a patient will be readmitted in <30 days. 
                  A new diabetic readmission reduction program intervention will use this model in 
                  order to target patients at high risk for readmission. Models will be evaluated on AUC and False Positive Rates.'),
                br(),
                h3('Data'),
                print('Click '),
                a('here',style="color:navy" , href='https://www.hindawi.com/journals/bmri/2014/781670/'),
                print(' for link to dataset.'),
                p('Beata Strack, Jonathan P. DeShazo, Chris Gennings, Juan L. Olmo, Sebastian Ventura,Krzysztof J. Cios, and John N. Clore,
                  "Impact of HbA1c Measurement on Hospital Readmission Rates: Analysis of 70,000 Clinical Database Patient Records," 
                  BioMed Research International, vol. 2014, Article ID 781670, 11 pages, 2014.')
                )), 
    
    tabItem("background",
            box(h1('Background Research1',align='center'),background='purple',width=24),
            box(background='light-blue', width=24,
                p('about'),
                p('about'),
                p('about')
            ),
            box(h1('Background Research2',align='center'),background='purple',width=24),
            box(background='light-blue', width=24,
                p('about'),
                p('about'),
                p('about')
            )
    ),
    tabItem("eda",
            tabBox(id = "edatabs",width = 12,
                   tabPanel(title = "Outcome",
                            fluidRow(box(width = 12,
                                         plotlyOutput("outcome")
                            ))),
                   
                   tabPanel(title = "A1C level",
                            fluidRow(box(width = 12,
                                         plotlyOutput("A1C")
                            ))),
                   
                   tabPanel(title = "Diagnoses",
                            fluidRow(box(width = 12,
                                         plotlyOutput("diagnoses")
                            ))),
                   
                   tabPanel(title = "Days in hospital",
                            fluidRow(box(width = 12,
                            plotlyOutput("days_hospital_hist")
                            ))),
                   
                   tabPanel(title = "Num of labs",
                            fluidRow(box(width = 12,
                              plotlyOutput("num_lab_hist")
                            ))),
                   
                   tabPanel(title = "Num of meds",
                            fluidRow(box(width = 12,
                              plotlyOutput("num_meds_hist")
                            ))),
                   
                   tabPanel(title = "Age Groups",
                            fluidRow(box(width = 12,
                                         plotlyOutput("age_hist")
                                         ))),
                   
                   tabPanel(title = "Metfomin&Insulin",
                            fluidRow(box(width = 6,
                                         plotlyOutput("metformin_hist")
                                         ),
                                     box(width = 6,
                                         plotlyOutput("insulin_hist")
                                     ))),
                   
                   tabPanel(title = "Race",
                            fluidRow(box(width = 12,
                                         plotlyOutput("race_hist")
                                         )))
            )),
    
    tabItem("results",
            fluidRow(
              column(4,
                     h4('Confusion Matrix',align='center'),
                     verbatimTextOutput(outputId="cMatrix_text")
                     ),
                
              column(8,tabBox(id = "resultstabs",width = 12,
                              tabPanel(title = "ROC Curve",
                                  plotOutput("aucplot_plot"),
                                  p('Area under the curve: 0.6841'),
                                  p('95% CI: 0.6725-0.6958 (DeLong)')),
                              tabPanel(title = "Definitions",
                                  h4('ROC Curve'),
                                  p("Receiver Operating Characteristic curve,
                                    is a graphical plot that illustrates the diagnostic ability of a binary classifier system as 
                                    its discrimination threshold is varied"),
                                  p("The ROC curve is created by plotting the true positive rate against the false positive rate 
                                    at various threshold settings"),
                                  br(),
                                  h4('True Positive (TP)'),
                                  p('Correctly classified as the class of interest'),
                                  br(),
                                  h4('True Negative (TN)'),
                                  p('Correctly classified as not the class of interest'),
                                  br(),
                                  h4('False Positive (FP)'),
                                  p('Incorrectly classified as the class of interest. It is often called "Type I" error'),
                                  br(),
                                  h4('False Negative (FN)'),
                                  p('Incorrectly classified as not the class of interest. It is often called "Type II" error'),
                                  br(),
                                  h4('Confidence Intervals (CI)'),
                                  p('In pROC packge, the ci function computes the CI of a ROC curve. By default, the 95% CI are computed with 
                                    2000 stratified bootstrap replicates'),
                                  br(),
                                  h4('Confusion Matrix'),
                                  p('A confusion matrix is a table that is often used to describe the performance of a classification model on 
                                    a set of test data for which the true values are known'),
                                  br(),
                                  h4('Accuracy'),
                                  p('Accuracy = (TP+TN)/total ')
                                  
                                  
                                  )))
            )),
    
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
                                                tabPanel(title = "Adinistrative Information",
                                                         h4("Admission Type:"),
                                                         textOutput("hi_at"),
                                                         h4("Admission Source:"),
                                                         textOutput("hi_as"),
                                                         h4("Number of Days n Hospital:"),
                                                         textOutput("hi_th"),
                                                         h4("Discharge Disposition:"),
                                                         textOutput("hi_dd"),
                                                         h4("Number of Inpatient Visits (Prior Year):"),
                                                         textOutput("hi_iv"),
                                                         h4("Number of Outpatient Visits (Prior Year):"),
                                                         textOutput("hi_ov"),
                                                         h4("Number of Emergency Visits (Prior Year):"),
                                                         textOutput("hi_ev")),
                                                tabPanel(title = "Test Results",
                                                         print("Test values"))))),
            print("Have a clickable table, tabs for patient information")),
    
    tabItem("cost",
            print("Back to Adrian/Tim for their cost information"))
    
  )) 
)