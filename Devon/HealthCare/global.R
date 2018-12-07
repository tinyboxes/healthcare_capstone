library(shiny)
library(tidyverse)
library(shinydashboard)
library(DT)
library(plotly)

df<- read.csv(file = "./DiabetesTrainTestForShiny.csv",stringsAsFactors = F)
#Edit Variables to Be More Readable to the User
#Edit Race
df$race[df$race == ""] = "Not Registered"
df$race[df$race == "AfricanAmerican"] = "African American"
#Edit Age
df = df %>%
  mutate(.,age = case_when(age == 1 ~ "0 - 10",
                           age == 2 ~ "10 - 20",
                           age == 3 ~ "20 - 30",
                           age == 4 ~ "30 - 40",
                           age == 5 ~ "40 - 50",
                           age == 6 ~ "50 - 60",
                           age == 7 ~ "60 - 70",
                           age == 8 ~ "70 - 80",
                           age == 9 ~ "80 - 90",
                           age == 10 ~ "90 - 100"))
#Edit discharge Disposition
df = df %>%
  mutate(.,discharge_disposition = case_when(discharge_disposition == "hhealth" ~ "Healthcare at Home",
                                             discharge_disposition == "home" ~ "Home, No Healthcare Required",
                                             discharge_disposition == "hospice" ~ "Hospice Care",
                                             discharge_disposition == "hospital" ~ "Back to Hospital",
                                             discharge_disposition == "leftAMA" ~ "Left Against Medical Advice",
                                             discharge_disposition == "nursing" ~ "Into Care of Nurse",
                                             discharge_disposition == "outpatient" ~ "Outpatient Care",
                                             discharge_disposition == "psych" ~ "Mental Health Institution",
                                             discharge_disposition == "unknown" ~ "Not Registered"))
df_train<-df%>%filter(IsTrain==1) # for EDA
df_test<-df%>%filter(IsTrain==0) # no prediction result in this df
test_pred = read.csv(file = "./TestPredictions.csv")
test_pred[,1:2] = NULL
colnames(test_pred)[2] = "predict_cat"
df_test = cbind(test_pred,df_test)
df_test$predict_cat = ifelse(df_test$predict_cat == 0, "No","Yes")


#graph for days in hospital  in EDA
days_hospital<- group_by(df_train,time_in_hospital,readmitted)%>%
  summarise(count=n())%>%
  ggplot(aes(x=time_in_hospital,y=count,fill=readmitted))+geom_bar(stat="identity",position='dodge')

#graph for number of labs in EDA
num_lab<-group_by(df_train,num_lab_procedures,readmitted)%>%
  summarise(count=n())%>%
  ggplot(aes(x=num_lab_procedures,y=count,fill=readmitted,))+geom_bar(stat="identity",position='dodge')
  #ggplot(aes(x=num_medications,y=count,color=readmitted))+geom_line()

#graph for number of medications in EDA
num_meds<-group_by(df_train,num_medications,readmitted)%>%
  summarise(count=n())%>%
  ggplot(aes(x=num_medications,y=count,fill=readmitted,))+geom_bar(stat="identity",position='dodge')

##First tab patient table
f.t.p.t. = df_test %>%
  select(.,predict_cat,encounter_id,patient_nbr,age,race,gender)
  