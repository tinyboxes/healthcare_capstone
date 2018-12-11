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
  ##For patient page 1
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
  ##
  
  ##For patient Tab 2
  h.i.encounter = reactive({
    s = input$table_rows_selected
    print(as.character(s.t.p.t.[s,]))
  })
  output$hi_at = renderText({
    h.i.encounter()[1]
  })
  output$hi_as = renderText({
    h.i.encounter()[2]
  })
  output$hi_th = renderText({
    h.i.encounter()[4]
  })
  output$hi_dd = renderText({
    h.i.encounter()[3]
  })
  output$hi_iv = renderText({
    h.i.encounter()[5]
  })
  output$hi_ov = renderText({
    h.i.encounter()[6]
  })
  output$hi_ev = renderText({
    h.i.encounter()[7]
  })
  d.t.encounter = reactive({
    s = input$table_rows_selected
    print(as.character(t.t.p.t.[s,]))
  })
  output$dt_pd = renderText({
    d.t.encounter()[1]
  })
  output$dt_a1c = renderText({
    d.t.encounter()[2]
  })
  output$dt_mgs = renderText({
    d.t.encounter()[3]
  })
  ###For secondary diagnoses
  s.d.vector = reactive({
    s = input$table_rows_selected
    prime = as.character(t.t.p.t.[s,1])
    secondary = vector(mode = "character",length = 16)
    for(i in 1:15){
      secondary[i] = ifelse(diags[s,i] == 1,catvec[i],NA)
    }
    secondary[16] = ifelse(rowSums(diabdiags[s,]) != 0,catvec[16],NA)
    secondary = secondary[!is.na(secondary)]
    fsecondary = setdiff(secondary,prime)
    fsecondary = paste(fsecondary,collapse = ", ")
    fsecondary = ifelse(nchar(fsecondary) == 0, "No Additional Diagnoses",fsecondary)
    print(fsecondary)
  })
  output$s_d = renderText({
    s.d.vector()
  })
  #days in hospital-EDA  
  output$days_hospital_hist<- renderPlot({
    days_hospital
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
  
  #aucplot
  output$aucplot_plot<-renderPlot({
    plot(modelroc, print.auc=TRUE, auc.polygon=TRUE,
         grid=c(0.1, 0.2), grid.col=c("green", "red"),
         max.auc.polygon=TRUE, auc.polygon.col="skyblue", print.thres=TRUE)
  })
  
  output$cMatrix_text<-renderPrint({
    cMatrix
  })
  
})
