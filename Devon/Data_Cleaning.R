library(VIM)
library(tidyverse)
library(ggplot2)
library(caret)
library(psych)

##reading in the data
train.bi = read.csv("data/train_bi.csv",stringsAsFactors = F)
test.bi = read.csv("data/test_bi.csv",stringsAsFactors = F)
id_df = read_csv("data/IDs_mapping.csv")

##creating datatype column as a failsafe
train.bi$datatype = "TRAIN"
test.bi$datatype = "TEST"

##Binding the two together
diab_df = rbind(train.bi,test.bi)

aggr(diab_df,plot = F)
##Me creating the V variables across diagnoses
otherV1 = names(table(diab_df %>%
                        select(.,diag_1) %>%
                        filter(.,str_detect(diag_1,"V"))))

otherV2 = names(table(diab_df %>%
                        select(.,diag_2) %>%
                        filter(.,str_detect(diag_2,"V"))))

otherV3 = names(table(diab_df %>%
                        select(.,diag_3) %>%
                        filter(.,str_detect(diag_3,"V"))))

##Me creating one large vector of the V codes
combV1 = union(otherV1,otherV2)
combV2 = union(combV1,otherV3)

##Same thing as before, but with E codes
otherE1 = names(table(diab_df %>%
                        select(.,diag_1) %>%
                        filter(.,str_detect(diag_1,"E"))))

otherE2 = names(table(diab_df %>%
                        select(.,diag_2) %>%
                        filter(.,str_detect(diag_2,"E"))))

otherE3 = names(table(diab_df %>%
                        select(.,diag_3) %>%
                        filter(.,str_detect(diag_3,"E"))))

combE1 = union(otherE1,otherE2)
combE2 = union(combE1,otherE3)

##Me creating vectors with the numbers of codes, as per Table 2
other = c(290:319,combV2,combE2,280:289,320:359,630:679,360:389,740:759,365.44)
circ = as.character(c(390:459,785))
resp = as.character(c(460:519,786))
diges = as.character(c(520:579,787,783))
inj = as.character(c(800:999))
musc = as.character(c(710:739))
geni = as.character(c(580:629,788,789))
neo = as.character(c(140:239,780,781,784,790:799,240:249,251:279,680:709,782,001:139))
diab = as.character(c(seq(250,250.99,by = .01)))

##Me transforming the first diagnoses into categories
diab_df = diab_df %>%
  mutate(.,diag_1_cat = case_when(diag_1 %in% circ ~ "Circulatory",
                                  diag_1 %in% resp ~ "Respiratory",
                                  diag_1 %in% diges ~ "Digestive",
                                  diag_1 %in% inj ~ "Injury",
                                  diag_1 %in% musc ~ "Musculoskeletal",
                                  diag_1 %in% geni ~ "Genitourinary",
                                  diag_1 %in% neo ~ "Neoplasms",
                                  diag_1 %in% diab ~ "Diabetes",
                                  diag_1 %in% other ~ "Other",
                                  TRUE ~ NA_character_))
aggr(diab_df,plot = F)
table(diab_df$diag_1_cat)
sum(is.na(diab_df$diag_1_cat))
tot_diag = c(circ,resp,diges,inj,musc,geni,neo,diab,other)
sort(setdiff(diab_df$diag_1,tot_diag))

##Me transforming the second diagnoses into categories
diab_df = diab_df %>%
  mutate(.,diag_2_cat = case_when(diag_2 %in% circ ~ "Circulatory",
                                  diag_2 %in% resp ~ "Respiratory",
                                  diag_2 %in% diges ~ "Digestive",
                                  diag_2 %in% inj ~ "Injury",
                                  diag_2 %in% musc ~ "Musculoskeletal",
                                  diag_2 %in% geni ~ "Genitourinary",
                                  diag_2 %in% neo ~ "Neoplasms",
                                  diag_2 %in% diab ~ "Diabetes",
                                  diag_2 %in% other ~ "Other",
                                  TRUE ~ NA_character_))

table(diab_df$diag_2_cat)
sum(is.na(diab_df$diag_2_cat))
tot_diag = c(circ,resp,diges,inj,musc,geni,neo,diab,other)
sort(setdiff(diab_df$diag_2,tot_diag))

##?,783,789

##Me transforming the third diagnoses into categories
diab_df = diab_df %>%
  mutate(.,diag_3_cat = case_when(diag_3 %in% circ ~ "Circulatory",
                                  diag_3 %in% resp ~ "Respiratory",
                                  diag_3 %in% diges ~ "Digestive",
                                  diag_3 %in% inj ~ "Injury",
                                  diag_3 %in% musc ~ "Musculoskeletal",
                                  diag_3 %in% geni ~ "Genitourinary",
                                  diag_3 %in% neo ~ "Neoplasms",
                                  diag_3 %in% diab ~ "Diabetes",
                                  diag_3 %in% other ~ "Other",
                                  TRUE ~ NA_character_))

table(diab_df$diag_3_cat)
sum(is.na(diab_df$diag_3_cat))
tot_diag = c(circ,resp,diges,inj,musc,geni,neo,diab,other)
sort(setdiff(diab_df$diag_3,tot_diag))

aggr(diab_df,plot = F)

NROW(diab_df$diag_3[diab_df$diag_3 == "789"])

nrow(diab_df %>%
       select(.,contains("diag_3")) %>%
       filter(.,diag_3 == "789"))
str(diab_df)


##192 + 42 + 1085

##Me creating variables stating "Did the fall into X category across the three diagnoses)
diab_df = diab_df %>%
  mutate(
    .,
    diag_Circulatory = case_when(
      diag_1_cat == "Circulatory" |
        diag_2_cat == "Circulatory" |
        diag_3_cat == "Circulatory" ~ "Yes",
      TRUE ~ "No"
    ),
    diag_Diabetes = case_when(
      diag_1_cat == "Diabetes" |
        diag_2_cat == "Diabetes" |
        diag_3_cat == "Diabetes" ~ "Yes",
      TRUE ~ "No"
    ),
    diag_Digestive = case_when(
      diag_1_cat == "Digestive" |
        diag_2_cat == "Digestive" |
        diag_3_cat == "Digestive" ~ "Yes",
      TRUE ~ "No"
    ),
    diag_Genitourinary = case_when(
      diag_1_cat == "Genitourinary" |
        diag_2_cat == "Genitourinary" |
        diag_3_cat == "Genitourinary" ~ "Yes",
      TRUE ~ "No"
    ),
    diag_Injury = case_when(
      diag_1_cat == "Injury" |
        diag_2_cat == "Injury" |
        diag_3_cat == "Injury" ~ "Yes",
      TRUE ~ "No"
    ),
    diag_Musculoskeletal = case_when(
      diag_1_cat == "Musculoskeletal" |
        diag_2_cat == "Musculoskeletal" |
        diag_3_cat == "Musculoskeletal" ~ "Yes",
      TRUE ~ "No"
    ),
    diag_Neoplasms = case_when(
      diag_1_cat == "Neoplasms" |
        diag_2_cat == "Neoplasms" |
        diag_3_cat == "Neoplasms" ~ "Yes",
      TRUE ~ "No"
    ),
    diag_Other = case_when(
      diag_1_cat == "Other" |
        diag_2_cat == "Other" |
        diag_3_cat == "Other" ~ "Yes",
      TRUE ~ "No"
    ),
    diag_Respiratory = case_when(
      diag_1_cat == "Respiratory" |
        diag_2_cat == "Respiratory" |
        diag_3_cat == "Respiratory" ~ "Yes",
      TRUE ~ "No"
    )
  )


#Me changing the column names for admission type, discharge, and admission source for easier joining
colnames(diab_df)[7:9] = c("admission_type_id_num","discharge_disposition_id_num","admission_source_id_num")

##creating an admission type dataset
admiss_type = id_df[1:8,]
colnames(admiss_type) = c("admission_type_id_num","admission_type_id_cat")
##Originally a character vector, changing it to an integer for easier joining
admiss_type$admission_type_id_num = as.integer(admiss_type$admission_type_id_num)

##Same as above, but with discharge
disc_disp = id_df[10:40,]
colnames(disc_disp) = c("discharge_disposition_id_num","discharge_disposition_id_cat")
disc_disp = disc_disp[-1,]
disc_disp$discharge_disposition_id_num = as.integer(disc_disp$discharge_disposition_id_num)

##Same as above, but with admission sourcing
admiss_sour = id_df[42:67,]
colnames(admiss_sour) = c("admission_source_id_num","admission_source_id_cat")
admiss_sour = admiss_sour[-1,]
admiss_sour$admission_source_id_num = as.integer(admiss_sour$admission_source_id_num)
##Left joining
diab_df = left_join(diab_df,admiss_type)
diab_df = left_join(diab_df,disc_disp)
diab_df = left_join(diab_df,admiss_sour)

##Remove weight
diab_df$weight = NULL

aggr(diab_df,plot = F)

str(diab_df$payer_code)

colnames(diab_df)

nearZeroVar(diab_df,saveMetrics = T)

table(diab_df$acetohexamide)

diab_df = diab_df %>%
  mutate(.,metformin.bi = case_when(metformin == "No" ~ "No",
                                    TRUE ~ "Yes"),
         repaglinide.bi = case_when(repaglinide == "No" ~ "No",
                                  TRUE ~ "Yes"),
         nateglinide.bi = case_when(nateglinide == "No" ~ "No",
                                  TRUE ~ "Yes"),
         chlorpropamide.bi = case_when(chlorpropamide == "No" ~ "No",
                                  TRUE ~ "Yes"),
         glimepiride.bi = case_when(glimepiride == "No" ~ "No",
                                  TRUE ~ "Yes"),
         acetohexamide.bi = case_when(acetohexamide == "No" ~ "No",
                                  TRUE ~ "Yes"),
         glipizide.bi = case_when(glipizide == "No" ~ "No",
                                  TRUE ~ "Yes"),
         glyburide.bi = case_when(glyburide == "No" ~ "No",
                                  TRUE ~ "Yes"),
         tolbutamide.bi = case_when(tolbutamide == "No" ~ "No",
                                  TRUE ~ "Yes"),
         pioglitazone.bi = case_when(pioglitazone == "No" ~ "No",
                                  TRUE ~ "Yes"),
         rosiglitazone.bi = case_when(rosiglitazone == "No" ~ "No",
                                  TRUE ~ "Yes"),
         acarbose.bi = case_when(acarbose == "No" ~ "No",
                                  TRUE ~ "Yes"),
         miglitol.bi = case_when(miglitol == "No" ~ "No",
                                  TRUE ~ "Yes"),
         troglitazone.bi = case_when(troglitazone == "No" ~ "No",
                                  TRUE ~ "Yes"),
         tolazamide.bi = case_when(tolazamide == "No" ~ "No",
                                  TRUE ~ "Yes"),
         examide.bi = case_when(examide == "No" ~ "No",
                                  TRUE ~ "Yes"),
         citoglipton.bi = case_when(citoglipton == "No" ~ "No",
                                  TRUE ~ "Yes"),
         insulin.bi = case_when(insulin == "No" ~ "No",
                                  TRUE ~ "Yes"),
         glyburide.metformin.bi = case_when(glyburide.metformin == "No" ~ "No",
                                  TRUE ~ "Yes"),
         glipizide.metformin.bi = case_when(glipizide.metformin == "No" ~ "No",
                                  TRUE ~ "Yes"),
         glimepiride.pioglitazone.bi = case_when(glimepiride.pioglitazone == "No" ~ "No",
                                            TRUE ~ "Yes"),
         metformin.rosiglitazone.bi = case_when(metformin.rosiglitazone == "No" ~ "No",
                                            TRUE ~ "Yes"),
         metformin.pioglitazone.bi = case_when(metformin.pioglitazone == "No" ~ "No",
                                            TRUE ~ "Yes"),
         )

table(diab_df$max_glu_serum)

expired = c(11,19:21)

diab_df = diab_df %>%
  filter(.,!discharge_disposition_id_num %in% expired)

diab_df = diab_df %>%
  select(.,-admission_type_id_num,-discharge_disposition_id_num,-admission_source_id_num,-encounter_id,-patient_nbr)

is.na(diab_df) = "Missing"
train.bi = diab_df %>%
  filter(.,datatype == "TRAIN")

test.bi = diab_df %>%
  filter(.,datatype == "TEST")

str(diab_df)
