library(shiny)
library(tidyverse)
library(shinydashboard)
library(DT)
library(plotly)
library(pROC)
library(caret)


df<- read.csv(file = "./DiabetesTrainTestForShiny.csv",stringsAsFactors = FALSE)
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

##Correcting Admission Type - Devon
df = df %>%
  mutate(.,admission_type_id = case_when(admission_type_id == 1 ~ "Emergency",
                                         admission_type_id == 2 ~ "Urgent",
                                         admission_type_id == 3 ~ "Elective",
                                         admission_type_id == 4 ~ "Newborn",
                                         admission_type_id == 5 ~ "Unknown",
                                         admission_type_id == 7 ~ "Trauma Center"))
##Correcting Admission Source - Devon
df = df %>%
  mutate(.,admission_source_id = case_when(admission_source_id == 1 ~ "Physician Referral",
                                           admission_source_id == 2 ~ "Clinic Referral",
                                           admission_source_id == 3 ~ "HMO Referral",
                                           admission_source_id == 4 ~ "Transfer from a Hospital",
                                           admission_source_id == 5 ~ "Transfer from a Skilled Nursing Facility",
                                           admission_source_id == 6 ~ "Transfer from another Health Care Facility",
                                           admission_source_id == 7 ~ "Emergency Room",
                                           admission_source_id == 8 ~ "Other"))
df = df %>%
  mutate(.,A1Cresult = case_when(A1Cresult == "NotTaken" ~ "Not Taken",
                                 A1Cresult == "Norm" ~ "Normal",
                                 A1Cresult == ">7" ~ ">7",
                                 A1Cresult == ">8" ~ ">8"))

df = df %>%
  mutate(.,max_glu_serum = case_when(max_glu_serum == "NotTaken" ~ "Not Taken",
                                     max_glu_serum == "Norm" ~ "Normal",
                                     max_glu_serum == ">200" ~ ">200",
                                     max_glu_serum == ">300" ~ ">300"))

df = df %>%
  mutate(.,primarydiag = case_when(primarydiag == "blooddis" ~ "Blood Disorder",
                                   primarydiag == "circulatory" ~ "Circulatory",
                                   primarydiag == "digestive" ~ "Digestive",
                                   primarydiag == "infection" ~ "Infection",
                                   primarydiag == "injury" ~ "Injury",
                                   primarydiag == "mentaldis" ~ "Mental Disorder",
                                   primarydiag == "metabolic" ~ "Metabolic",
                                   primarydiag == "musculoskeletal" ~ "Musculoskeletal",
                                   primarydiag == "neoplasm" ~ "Neoplasm",
                                   primarydiag == "nervous" ~ "Nervous",
                                   primarydiag == "Nothing" ~ "Diabetes",
                                   primarydiag == "other" ~ "Other",
                                   primarydiag == "pregnancy" ~ "Pregnancy",
                                   primarydiag == "respiratory" ~ "Respiratory",
                                   primarydiag == "skin" ~ "Skin",
                                   primarydiag == "urogenital" ~ "Urogenital"))


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
                      ggplot(aes(x=readmitted,y=count,fill=readmitted))+geom_bar(stat="identity",position='dodge') 
                    + theme(plot.subtitle = element_text(vjust = 1), plot.caption = element_text(vjust = 1)) 
                    +labs(title = "Number of Patients for Readmission Status",x = "Readmitted", y = "Number Of Patients"))%>%
  layout(margin=m)

#graph for A1C  in EDA
A1C <- ggplotly(group_by(df_train, A1Cresult, readmitted) %>%
                  summarise(count=n())%>%
                  ggplot(aes(x=A1Cresult,y=count,fill=readmitted))+geom_bar(stat="identity",position='dodge') 
                + theme(plot.subtitle = element_text(vjust = 1), plot.caption = element_text(vjust = 1)) 
                +labs(title = "Number of Readmissions Based on A1C Results", x = "A1C Results", y = "Number of Patients") 
                + scale_x_discrete(limits=c("Not Taken","Normal",">7",">8")))%>%
  layout(margin=m)

#graph for diagnoses  in EDA
diagnoses <- ggplotly(group_by(df_train, number_diagnoses, readmitted) %>%
                        summarise(count=n()) %>%
                        filter(.,number_diagnoses < 10) %>%
                        ggplot(aes(x=number_diagnoses,y=count,fill=readmitted))
                      +geom_bar(stat="identity",position='dodge') 
                      + scale_x_continuous(breaks = seq(1,10,by = 1)) 
                      + theme(plot.subtitle = element_text(vjust = 1), plot.caption = element_text(vjust = 1)) 
                      +labs(title = "Number of Patients Based Vs. Number of Diagnoses", x = "Number of Diagnoses", y = "Number of Patients"))%>%
  layout(margin=m)

#graph for days in hospital  in EDA
days_hospital<- ggplotly(group_by(df_train,time_in_hospital,readmitted)%>%
                           summarise(count=n())%>%
                           ggplot(aes(x=time_in_hospital,y=count,fill=readmitted))+geom_bar(stat="identity",position='dodge') 
                         + theme(plot.subtitle = element_text(vjust = 1), plot.caption = element_text(vjust = 1)) 
                         +labs(title = "Number of Patients Vs. Days Spent in Hospital", x = "Time in Hospital (# Days)", y = "Number of Patients"))%>%
  layout(margin=m)

#graph for number of labs in EDA
num_lab<-ggplotly(group_by(df_train,num_lab_procedures,readmitted)%>%
                    summarise(count=n())%>%
                    ggplot(aes(x=num_lab_procedures,y=count,fill=readmitted))+geom_bar(stat="identity",position='dodge') 
                  + theme(plot.subtitle = element_text(vjust = 1), plot.caption = element_text(vjust = 1)) 
                  +labs(title = "Number of Patients Vs. Number of Lab Procedures",x = "Number of Lab Procedures", y = "Number of Patients"))%>%
  layout(margin=m)


#graph for number of medications in EDA
num_meds<-ggplotly(group_by(df_train,num_medications,readmitted)%>%
                     summarise(count=n())%>%
                     ggplot(aes(x=num_medications,y=count,fill=readmitted))+geom_bar(stat="identity",position='dodge') 
                   + theme(plot.subtitle = element_text(vjust = 1), plot.caption = element_text(vjust = 1)) 
                   +labs(title = "Number of Patients Vs. Number of Medications", x = "Number of Medications", y = "Number of Patients"))%>%
  layout(margin=m)

#graph for age in EDA
age<-ggplotly(group_by(df_train,age,readmitted)%>%
                summarise(count=n())%>%
                ggplot(aes(x=age,y=count,fill=readmitted))+geom_bar(stat="identity",position='dodge') 
              + theme(plot.subtitle = element_text(vjust = 1),  plot.caption = element_text(vjust = 1)) 
              +labs(title = "Number of Patients Vs. Age Bracket", x = "Age Bracket", y = "Number of Patients"))%>%
  layout(margin=m)

#graph for Metformin in EDA
metformin<-ggplotly(group_by(df_train,med_metformin,readmitted)%>%
                      summarise(count=n())%>%
                      ggplot(aes(x=med_metformin,y=count,fill=readmitted))+geom_bar(stat="identity",position='dodge') 
                    + theme(plot.subtitle = element_text(vjust = 1),  plot.caption = element_text(vjust = 1)) 
                    +labs(title = "Number of Patients Vs. Metformin Use", x = "Metformin Use", y = "Number of Patients") 
                    + scale_x_discrete(limits=c("No","Steady","Down","Up")))%>%
  layout(margin=m)

#graph for insulin in EDA
insulin<-ggplotly(group_by(df_train,med_insulin,readmitted)%>%
                    summarise(count=n())%>%
                    ggplot(aes(x=med_insulin,y=count,fill=readmitted))+geom_bar(stat="identity",position='dodge') 
                  + theme(plot.subtitle = element_text(vjust = 1), plot.caption = element_text(vjust = 1)) 
                  +labs(title = "Number of Patients Vs. Insulin Use", x = "Insulin Use", y = "Number of Patients",fill = "Readmitted") 
                  + scale_x_discrete(limits=c("No","Steady","Down","Up")))%>%
  layout(margin=m)

#graph for race in EDA
race<-ggplotly(group_by(df_train,race,readmitted)%>%
                 summarise(count=n())%>%
                 ggplot(aes(x=race,y=count,fill=readmitted))+geom_bar(stat="identity",position='dodge') 
               + theme(plot.subtitle = element_text(vjust = 1),plot.caption = element_text(vjust = 1)) 
               +labs(title = "Number of Patients Vs. Race",x = "Race", y = "Number of Patients"))%>%
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
##Second tab patient table
s.t.p.t. = df_test %>%
  select(.,admission_type_id,admission_source_id,discharge_disposition,time_in_hospital,number_inpatient,number_outpatient,number_emergency)
##Third tab
t.t.p.t. = df_test %>%
  select(.,primarydiag,A1Cresult,max_glu_serum)

##For secondary diagnoses
diags = df_test[,51:65]
diabdiags = df_test[,66:73]
catvec = c("Blood Disorder","Circulatory","Digestive","Infection","Injury","Mental Disorder","Metabolic",
           "Musculoskeletal","Neoplasm","Nervous","Other","Pregnancy","Respiratory","Skin","Urogenital","Diabetes")


### Cost Function ###

drp = function(True_positive_rate, #.59 True Positive rate -- (based on confusion matrix of test data)
               False_positive_rate, #.16 False Positive rate -- (based on confusion matrix of test data)
               Readmission_rate, #.1 readmission rate -- (based on the readmission experience of our data, or through literature review)
               Patient_population, #100000 the size patient population being assessed
               Average_days , #average length of inpatient stay due to readmission
               Average_cost_per_day , #average daily cost of inpatient stay
               Average_prog_readmi_perc_drop , #average percentage of readmissions reduced once the Diabetes Management plan is implimented, derived from literature review
               Diabetes_mgmt_cost) #average per-patient cost of Diabetes Management Plan, based on projections of physician, discharge nurse, and home visiting nurse's time
  
{ Not_readmitted = (1 - Readmission_rate) * Patient_population # calculate the number of patients NOT readmitted
Readmitted = Readmission_rate * Patient_population # calculate the number of patients readmitted
True_Positives = True_positive_rate * Readmitted # calculate the number of TRUE Positives (i.e. those we correctly predicted would be readmitted)
False_Positives = False_positive_rate * Not_readmitted # calculate the number of FALSE Positives (those we predicted would be readmitted, but actually would not have been)
Average_stay_cost = Average_days * Average_cost_per_day #calculate the readmission cost based on the rate per day and the number of days
#calculate how much money the new program saves
Savings_on_Readmissions = (Average_stay_cost * True_Positives * Average_prog_readmi_perc_drop)

#calculate the additional expense of implimenting the program
Expense_of_diabetes_program = (Diabetes_mgmt_cost * (True_Positives + False_Positives))

#calculate the net savings of the program
Total_savings_of_program = Savings_on_Readmissions - Expense_of_diabetes_program

#calculate the savings in total expense resulting from switching between the old program -- and the DM program -- on a per-patient basis
Savings_of_Program_per_patient = Total_savings_of_program / Patient_population

new_readmission_rate = Readmission_rate - (Readmission_rate * True_positive_rate * Average_prog_readmi_perc_drop)
#calculate the new readmission rate under the Diabetes Management program

difference_in_readmission_rates = Readmission_rate - new_readmission_rate
#calculate the drop in readmission rates due to the Diabetes Management program is implimented

percent_drop_in_readmission_rates = (difference_in_readmission_rates / Readmission_rate) * 100
#calculate the percentage reduction in readmission rates due to the Diabetes Management program

#calculate the savings in total expense resulting from switching between the old program -- and the DM program -- on a per-patient basis
values2 = format(c(Total_savings_of_program,Savings_of_Program_per_patient,
                   difference_in_readmission_rates, percent_drop_in_readmission_rates),scientific = F)

results = c(paste0("Total Savings: ",values2[1]),paste0("Average Savings Per Patient: ",values2[2]),
            paste0("Reduction in Readmission Rate: ",values2[3]), paste0("Percent Reduction in Readmission Rate: ",values2[4]))

return(results)
}

### End Cost Function ###
  