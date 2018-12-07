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
  patienttable = df_test %>%
    select(.,encounter_id,patient_nbr,age,race,gender)
  output$table = renderDataTable(
    patienttable,
    server = F,
    selection = list(mode = 'single', selected = 1),
    rownames = FALSE,
    colnames = c("Encounter ID","Patient Number","Age","Race","Gender")
  )
 
  demo.encounter = reactive({
    s = input$table_rows_selected
    print(as.character(f.t.p.t.[s,]))
  })
  output$dp_c = renderText({
    demo.encounter()[1]
  })
  output$de_i = renderText({
    demo.encounter()[2]
  })
  output$dp_n = renderText({
    demo.encounter()[3]
  })
  output$d_a = renderText({
    demo.encounter()[4]
  })
  output$d_r = renderText({
    demo.encounter()[5]
  })
  output$d_g = renderText({
    demo.encounter()[6]
  })
  #days in hospital-EDA  
  output$days_hospital_hist<- renderPlot({
    days_hospital
  })
  
  # num of lab-EDA
  output$num_lab_hist<- renderPlot({
    num_lab
  })
  
  # num of lab-EDA
  output$num_meds_hist<- renderPlot({
    num_meds
  })
  
  
})
