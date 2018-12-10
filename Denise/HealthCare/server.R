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

  #aucplot
  output$aucplot_plot<-renderPlot({
    plot(modelroc, print.auc=TRUE, auc.polygon=TRUE,
         grid=c(0.1, 0.2), grid.col=c("green", "red"),
         max.auc.polygon=TRUE, auc.polygon.col="skyblue", print.thres=TRUE)
  })

  output$cMatrix_text<-renderPrint({
    cMatrix
  })

  #variable importance bar chart
  output$importance_bar <- renderPlotly({
    importance_bar
  })
    
  #user defined readmission pie chart (coord_polar not supported by Plotly)
  output$readmission_pie <- renderPlot({
    
    readmit_pie <- df_test %>%
      filter(gender %in% input$gender & race %in% input$race  & age %in% input$age & 
             time_in_hospital %in% input$time & num_procedures %in% input$numPro) %>% 
      group_by(predict_cat) %>%
      summarise(count = n()) %>%
      mutate(percent=count/sum(count)*100)
    
    
    readmit_pie %>%
      ggplot(aes(x = "", y = percent, fill = predict_cat)) +
      geom_bar(stat = "identity", color = "black")  +
      coord_polar(theta = "y", start=0) +
      geom_text(aes(label = paste0(predict_cat,":", round(percent), "%")), 
                position = position_stack(vjust = 0.5)) +
      scale_fill_discrete(guide=FALSE) +
      theme(axis.ticks = element_blank(),
            axis.text = element_blank(),
            axis.title = element_blank(),
            plot.caption = element_text(hjust = 0.5)) +
      ggtitle("Readmission Ratio for Select Variables")
    
  })
  
  #user defined variable pie chart (coord_polar not supported by Plotly)
  output$importance_pie <- renderPlot({
    
    imp_pie <- feat_imp %>%
      filter(Feature %in% input$feature) %>%
      select(Feature, Importance) %>%
      mutate(percent=Importance/sum(Importance)*100)
    
    imp_pie %>%
      ggplot(aes(x = factor(1), y = percent, fill = Feature)) +
      geom_bar(stat = "identity", color = "black")  +
      geom_text(aes(label = paste0(Feature, ":", round(percent), "%")), 
                position = position_stack(vjust = 0.5), size = 3) + 
      scale_fill_discrete(guide=FALSE) +
      coord_polar(theta = "y", start=0) +
      theme(axis.ticks = element_blank(),
            axis.text = element_blank(),
            axis.title = element_blank(),
            plot.caption = element_text(hjust = 0.5)) +
      ggtitle("Variable Contribution to Readmission")
    
  })

})
