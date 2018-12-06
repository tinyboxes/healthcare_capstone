library(shiny)
library(tidyverse)
library(shinydashboard)
library(DT)
library(dplyr)
library(ggplot2)


df<- read.csv(file = "./DiabetesTrainTestForShiny.csv")
df_train<-df%>%filter(IsTrain==1) # for EDA
df_test<-df%>%filter(IsTrain==0) # no prediction result in this df


#graph for days in hospital EDA
days_hospital<- ggplot(df_train,aes(x=time_in_hospital,y=readmitted))+geom_bar(stat="identity")

