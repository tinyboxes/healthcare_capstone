library(shiny)
library(tidyverse)
library(shinydashboard)
library(DT)
library(plotly)



df<- read.csv(file = "./DiabetesTrainTestForShiny.csv")
df_train<-df%>%filter(IsTrain==1) # for EDA
df_test<-df%>%filter(IsTrain==0) # no prediction result in this df

#graph for outcome  in EDA
outcome <- group_by(df_train, readmitted) %>%
  summarise(count=n())%>%
  ggplot(aes(x=readmitted,y=count,fill=readmitted))+geom_bar(stat="identity",position='dodge')

#graph for A1C  in EDA
A1C <- group_by(df_train, A1Cresult, readmitted) %>%
  summarise(count=n())%>%
  ggplot(aes(x=A1Cresult,y=count,fill=readmitted))+geom_bar(stat="identity",position='dodge')

#graph for diagnoses  in EDA
diagnoses <- group_by(df_train, number_diagnoses, readmitted) %>%
  summarise(count=n())%>%
  ggplot(aes(x=number_diagnoses,y=count,fill=readmitted))+geom_bar(stat="identity",position='dodge')

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
  