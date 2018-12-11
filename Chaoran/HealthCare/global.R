library(shiny)
library(tidyverse)
library(shinydashboard)
library(DT)
library(plotly)
library(pROC)
library(caret)

df<- read.csv(file = "./DiabetesTrainTestForShiny.csv",stringsAsFactors = F) #Diabetes DataSet
feat_imp = read.csv(file = "./feat_imp.csv",stringsAsFactors = F) #Feature Importance

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


### Start of EDA tab code###

m = list(
  l = 80,
  r = 100,
  b = 100,
  t = 50,
  pad = 0
)

#graph for outcome  in EDA
outcome <- ggplotly(group_by(df_train, readmitted) %>%
  summarise(count=n())%>%
  ggplot(aes(x=readmitted,y=count,fill=readmitted))+geom_bar(stat="identity",position='dodge'))%>%
  layout(margin=m)

#graph for A1C  in EDA
A1C <- ggplotly(group_by(df_train, A1Cresult, readmitted) %>%
  summarise(count=n())%>%
  ggplot(aes(x=A1Cresult,y=count,fill=readmitted))+geom_bar(stat="identity",position='dodge'))%>%
  layout(margin=m)

#graph for diagnoses  in EDA
diagnoses <- ggplotly(group_by(df_train, number_diagnoses, readmitted) %>%
  summarise(count=n())%>%
  ggplot(aes(x=number_diagnoses,y=count,fill=readmitted))+geom_bar(stat="identity",position='dodge'))%>%
  layout(margin=m)

#graph for days in hospital  in EDA
days_hospital<- ggplotly(group_by(df_train,time_in_hospital,readmitted)%>%
  summarise(count=n())%>%
  ggplot(aes(x=time_in_hospital,y=count,fill=readmitted))+geom_bar(stat="identity",position='dodge'))%>%
  layout(margin=m)

#graph for number of labs in EDA
num_lab<-ggplotly(group_by(df_train,num_lab_procedures,readmitted)%>%
  summarise(count=n())%>%
  ggplot(aes(x=num_lab_procedures,y=count,fill=readmitted))+geom_bar(stat="identity",position='dodge'))%>%
  layout(margin=m)
  #ggplot(aes(x=num_medications,y=count,color=readmitted))+geom_line()

#graph for number of medications in EDA
num_meds<-ggplotly(group_by(df_train,num_medications,readmitted)%>%
  summarise(count=n())%>%
  ggplot(aes(x=num_medications,y=count,fill=readmitted))+geom_bar(stat="identity",position='dodge'))%>%
  layout(margin=m)

#graph for age in EDA
age<-ggplotly(group_by(df_train,age,readmitted)%>%
  summarise(count=n())%>%
  ggplot(aes(x=age,y=count,fill=readmitted))+geom_bar(stat="identity",position='dodge'))%>%
  layout(margin=m)

#graph for Metformin in EDA
metformin<-ggplotly(group_by(df_train,med_metformin,readmitted)%>%
  summarise(count=n())%>%
  ggplot(aes(x=med_metformin,y=count,fill=readmitted))+geom_bar(stat="identity",position='dodge'))%>%
  layout(margin=m)

#graph for insulin in EDA
insulin<-ggplotly(group_by(df_train,med_insulin,readmitted)%>%
  summarise(count=n())%>%
  ggplot(aes(x=med_insulin,y=count,fill=readmitted))+geom_bar(stat="identity",position='dodge'))%>%
  layout(margin=m)

#graph for race in EDA
race<-ggplotly(group_by(df_train,race,readmitted)%>%
  summarise(count=n())%>%
  ggplot(aes(x=race,y=count,fill=readmitted))+geom_bar(stat="identity",position='dodge'))%>%
  layout(margin=m)
### End of EDA tab code ###


### start of Results tab code###
test_obs <- ifelse(df_test$readmitted=="Yes",1,0)
pred_obs <- ifelse(df_test$predict_cat=='Yes',1,0)
modelroc <- roc(test_obs, df_test$predict_prob)
cMatrix <- confusionMatrix(as.factor(pred_obs),as.factor(test_obs),positive = '1')

### end of Results tab code###

### Prediction Visuals ###
# Feature Importance Bar Graph
importance_bar <- ggplotly(feat_imp %>%
                             top_n(20, Importance) %>%
                             ggplot() +
                             geom_bar(aes(x=reorder(Feature, Importance), y = Importance, fill=Importance), stat = "identity") +
                             coord_flip() + labs (x = 'Feature', y = 'Importance'), tooltip = c("x", "y"))

### End Prediction Visuals ###



##First tab patient table
f.t.p.t. = df_test %>%
  select(.,predict_cat,encounter_id,patient_nbr,age,race,gender)
