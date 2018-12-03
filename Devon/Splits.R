##Splitting the dataset into train and test, 80/20
beforesplit = read.csv("diabetic_data.csv",na.strings = "?",stringsAsFactors = F)

##Remove all data where readmission is over 30
beforesplit.bi = beforesplit %>%
  filter(., readmitted != ">30")

splits = createDataPartition(y = beforesplit.bi$readmitted,p = .8,list = F)
train.bi = beforesplit.bi[splits,]
test.bi = beforesplit.bi[-splits,]

write_csv(train.bi,"train_bi.csv")
write_csv(test.bi,"test_bi.csv")

splits.multi = createDataPartition(y = beforesplit$readmitted,p = .8,list = F)
train.multi = beforesplit[splits.multi,]
test.multi = beforesplit[-splits.multi,]

write_csv(train.multi,"train_multi.csv")
write_csv(test.multi,"test_multi.csv")
