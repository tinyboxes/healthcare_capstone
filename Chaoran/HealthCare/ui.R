
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
            box(title = "Overview and Public Health Perspective", solidHeader = TRUE, status = "primary",width=24,
                p("Diabetes Mellitus is a prominent and growing public health concern that costs the United States economy hundreds of billions 
                  of dollars each year. Hospital readmissions among diabetes patients are a prominent component behind these high costs."),
                p("Type 1 and 2 diabetes both relate to an inability of the body to manage blood sugar levels. Type 2 is much more common, and 
                  coincides highly with an unhealthy lifestyle."),
                p("Both types of diabetes can be successfully managed through implementing a \"Diabetes Management Program\", which coordinates the communication,
                  logistics, and education about the disease between medical staff, the patient, and the patient's support network."),
                p("A predictive tool capable of classifying diabetic patients with a \"high-risk\" of being readmitted to a hospital within 30 days of discharge
                  enables the identification of patients that would benefit most from a diabetes management program. This enables the allocation of resources
                  in a manner that optimally reduces costs, improves health outcomes, and saves lives.")
            ),
            box(title = "Overview and Public Health Perspective", solidHeader = TRUE, status = "primary",width=24,
                p('Further research was conducted to estimate values for additional variables that were not available within the dataset. These variables
                  proved necessary to transfer model predictions into the tangible financial and clinical recommendations necessary for business purposes.
                  Examples of these variables include:'),
                p('- the cost of hospital readmission'),
                p('- the cost of a diabetes management program'),
                p('- the success rate of a diabetes management program at preventing a 30-day readmission'),
                p('Other studies that aimed to predict the rate of hospital readmission across patients with diabetes and/or similar
                  chronic conditions were also reviewed. These studies identified additional variables that have been shown to be useful predictors 
                  of readmission, but were unfortunately not available within the dataset.'),
                p("Examples of additional desirable socioeconomic information might include a patient's:"),
                p('- zip code'),
                p('- personal support network'),
                p('- income level'),
                p('- education level'),
                p("Examples of additional desirable health information might include a patient's:"),
                p('- weight'),
                p('- BMI'),
                p('- blood pressure levels'),
                p('- smoking habits'),
                p('- access to regular primary care')
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
                                  p('95% CI: 0.6725-0.6958 (DeLong)'))
                              ))
            ),
            fluidRow(
              box(title = "Definitions", solidHeader = TRUE, status = "primary",width=24,
                  strong('ROC Curve'),
                  p("Receiver Operating Characteristic curve,is a graphical plot that illustrates the diagnostic ability of a binary classifier system as 
                     its discrimination threshold is varied. The ROC curve is created by plotting the true positive rate against the false positive rate at various threshold settings"),
                  strong('True Positive (TP)'),
                  p('Correctly classified as the class of interest'),
                  strong('True Negative (TN)'),
                  p('Correctly classified as not the class of interest'),
                  strong('False Positive (FP)'),
                  p('Incorrectly classified as the class of interest. It is often called "Type I" error'),
                  strong('False Negative (FN)'),
                  p('Incorrectly classified as not the class of interest. It is often called "Type II" error'),
                  strong('Confidence Intervals (CI)'),
                  p('In pROC packge, the ci function computes the CI of a ROC curve. By default, the 95% CI are computed with 
                                    2000 stratified bootstrap replicates'),
                  strong('Confusion Matrix'),
                  p('A confusion matrix is a table that is often used to describe the performance of a classification model on 
                                    a set of test data for which the true values are known'),
                  strong('Accuracy'),
                  p('Accuracy = (TP+TN)/total '),
                  strong('Sensitivity'),
                  p("Sensitivity = True Positive Rate = TP/(TP+FN"),
                  strong("Specificity"),
                  p("Specificity = TN / (TN + FP)"),
                  p("False Positive Rate (FPR) = 1 - Specificity")
                  )
              
            )
            ),
    
    tabItem("predictvis",
            fluidRow(
              box(id = "readmissioPie", width = 6,
                  plotOutput("readmission_pie"),
                  plotOutput("importance_pie")),
              tabBox(id = "predicttabs", width = 6,
                     tabPanel(title = "Variable Importance",
                              plotlyOutput("importance_bar"),
                              helpText('Above are the top 20 variables contributing to patient readmission.')),
                     
                     tabPanel(title = "User Options",
                              helpText("Select variables from the drop down boxes below."),
                              selectInput("gender",
                                          "Gender:", choices = unique(df_test$gender), selected = 'Male'),
                              selectInput("race",
                                          "Race:", choices = unique(df_test$race), selected = 'African American'),
                              selectInput("age",
                                          "Age Group:", choices = unique(df_test$age), selected = '30 - 40'),
                              
                              sliderInput("time",
                                          "Minimum Time in Hospital (days):", min = 1,
                                          max = 14, value = 1),
 
                              sliderInput("numPro",
                                          "Minimum Number of Medical Procedures:", min = 0,
                                          max = 6, value = 1)
        
                     ),
                     tabPanel(title = "Readmission Variables",
                              helpText('Select features from the drop down box below.'),
                              selectInput("feature",
                                          "Features: ", choices = feat_imp$Feature,
                                          multiple = TRUE, selected = c('age', 'time_in_hospital', 'num_medications')))
              ))
    ),
    
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
                                                tabPanel(title = "Diagnoses/Test Results",
                                                         h4("Primary Diagnosis:"),
                                                         textOutput("dt_pd"),
                                                         h4("Additional Diagoses:"),
                                                         textOutput("s_d"),
                                                         h4("A1C Results:"),
                                                         textOutput("dt_a1c"),
                                                         h4("Glucose Levels:"),
                                                         textOutput("dt_mgs")
                                                ))))),
    
    tabItem("cost",
            fluidRow(
              box(width = 3, title = "Parameters",
                  solidHeader = TRUE, status = "primary",
                  sliderInput(inputId = "pop",
                              label = "Patient Population",
                              value = 100000, min = 50000, max = 500000),
                  sliderInput(inputId = "rate",
                              label = "Readmission Rate",
                              value = 0.10, min = 0.0, max = 0.15,step = 0.01),
                  sliderInput(inputId = "stay",
                              label = "Hospital Stay (days)",
                              value = 4, min = 1, max = 14, step = 1),
                  sliderInput(inputId = "cost",
                              label = "Cost per Day (USD)",
                              value = 10000, min = 0, max = 50000, step = 100)
                  
              ),
              box(width = 8, title = "Cost Modeling and Finances",
                  h4(textOutput('savings')),
                  h4(textOutput('aveSavings')),
                  h4(textOutput('reduction')),
                  br(),
                  h5("Simplified Cost Saving Equation:"),
                  p(withMathJax("$$Total~Savings = (RC * TP * RP) - DMC * (TP + FP)$$")),
                  h5("Variables:"),
                  h6("TP = True Positive Count"),
                  h6("FP = False Positive Count"),
                  h6("RC = Cost of Readmission/Patient"),
                  h6("DMC = Cost of Diabeted Management Care/Patient"))
            ),
            
            fluidRow(
              box(width = 12, title = "Description of Total Savings Equation",
                  solidHeader = TRUE, status = "primary",
                  p("With a strong prediction model in hand, it was necessary to determine how much a diabetes
                    management (DM) program could save health service payers (i.e. a private insurer, public health
                    insurance such as Medicare or Medicaid, or the individual if they lack coverage). Many of the
                    numbers used to project these savings were estimates derived through literature review. Actual
                    values likely vary depending on a number of factors such as geography, and underlying differences
                    across patient populations and medical staff."),
                  p("A Shiny web application that enables the imputation of a range of values for these metrics
                    accounts for this variation. This application enables customized financial predictions tailored
                    meet the nuanced situations within various different health care scenarios. However specific
                    values were selected for the purposes of presentation."))
                  ),
            
            fluidRow(
              box(width = 12, title = "Savings on Readmissions",
                  solidHeader = TRUE, status = "primary",
                  p("The expense per readmission is quite high for the healthcare payer. Based on literature review,
                    it was estimated that the average cost per day of hospital care fluctuates around $10,000. Based
                    on the population within the dataset, the average length of a hospital stay was calculated to be
                    at 4.5 days. Therefore the estimated savings for each prevented readmission was calculated to be
                    approximately $45,000."),
                  p("Just because an at-risk individual receives a DM program, it is not guaranteed that a
                    readmission will be avoided. Even with perfect execution, it is possible that a comorbidity,
                    such as heart or liver disease, or any number of external factors may still result in a readmission.
                    The estimated success rate of the diabetes management program hovered around 39%."),
                  p("Therefore the savings from readmissions is calculated to be a from the product of:"),
                  p("- the per patient cost of readmission "),
                  p("- the number of true positives identified and enrolled within a DM program"),
                  p("- the success rate of a DM program at preventing a readmission"))
                  ),
            
            fluidRow(
              box(width = 12, title = "Expense of Diabetes Management Program",
                  solidHeader = TRUE, status = "primary",
                  p("Implementing the DM program requires an upfront expenditure on the part of the healthcare payer.
                    This expenditure is subtracted from the savings produced through reduced readmissions. The cost of
                    the DM program is based on the time of the physician, discharge nurse, and home visiting nurse, and
                    was estimated to be $500 per patient based on literature review. "),
                  p("However, not every readmission predicted through the model is accurate. A number of false positives
                    are also identified, and are still enrolled within the DM program. The upfront expenditure for the plan
                    must be applied to both the true, and false positive predictions of the model."),
                  p("Therefore expenditure from implementing DM program is determined by the product of:"),
                  p("- the cost of the DM program per enrolled patient"),
                  p("- the sum of both the true and false positives"),
                  p("Through variations of this basic equation, a number of other performance metrics relevant to the success
                    of the DM program may also be derived. Our Shiny application allows for the easy calculation of all of these
                    related metrics, based on the input parameters selected by the user. Examples of these additional
                    performance metrics include:"),
                  p("- the number of readmissions prevented "),
                  p("- the percentage reduction in readmissions"),
                  p("- the average savings realized from each diabetes patient"))
                  )
              )
                          
)))