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
  
  #feature importance bar-EDA  
  output$importance_bar <- renderPlotly({
    importance_bar
  })
  
  #feature importance pie-EDA
  output$importance_pie <- renderPlot({
    
    imp_pie <- feat_imp %>% 
      filter(Feature %in% input$feature ) %>% 
      select(Feature, Importance) %>%
      mutate(pos = cumsum(Importance)-0.5*Importance)
    
    pie <- imp_pie %>% 
      ggplot(aes(x = "", y = Importance, fill = Feature)) + 
      geom_bar(stat = "identity", color = "black")  + 
      scale_y_continuous(breaks = imp_pie$pos, # center labels
                         labels = imp_pie$Feature) +
      scale_fill_discrete(guide=FALSE) +
      coord_polar(theta = "y", start=0) +
      # geom_text(aes(label = Feature), position = position_stack(vjust = 0.5)) +
      # scale_y_continuous(expand = c(0,0)) +
      # coord_polar(theta = "y") +
      theme(axis.ticks=element_blank(), axis.text.y=element_blank())
    
    # feat_imp %>% 
    #   filter(Feature == 'num_procedures') %>%
    #   ggplot(aes(x=1, y = Importance, fill=Feature)) + 
    #   geom_bar(stat = "identity", color = "black")  + 
    #   coord_polar(theta = "y") + 
    #   scale_y_continuous(breaks= cumsum(feat_imp$Importance) - feat_imp$Importance/2, # center labels
    #                      labels=feat_imp$Feature) + scale_fill_discrete(guide=FALSE) +
    #   theme(axis.ticks=element_blank(),
    #         axis.text.y=element_blank())
  })
  
})
