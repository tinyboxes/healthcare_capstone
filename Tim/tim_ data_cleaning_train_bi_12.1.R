df = train_bi
library(dplyr)

#defining function '%!in%' to indicate selection of labels not within list
'%!in%' <- function(x,y)!('%in%'(x,y))

#y = colnames(df)

#transfroming the discharge_disposition_id into labels

df$discharge_disposition_id[df$discharge_disposition_id == 1] = "Discharged to home"
df$discharge_disposition_id[df$discharge_disposition_id == 2] = "Discharged/transferred to another short term hospital"
df$discharge_disposition_id[df$discharge_disposition_id == 3] = "Discharged/transferred to SNF"
df$discharge_disposition_id[df$discharge_disposition_id == 4] = "Discharged/transferred to ICF"
df$discharge_disposition_id[df$discharge_disposition_id == 5] = "Discharged/transferred to another type of inpatient care institution"
df$discharge_disposition_id[df$discharge_disposition_id == 6] = "Discharged/transferred to home with home health service"
df$discharge_disposition_id[df$discharge_disposition_id == 7] = "Left AMA"
df$discharge_disposition_id[df$discharge_disposition_id == 8] = "Discharged/transferred to home under care of Home IV provider"
df$discharge_disposition_id[df$discharge_disposition_id == 9] = "Admitted as an inpatient to this hospital"
df$discharge_disposition_id[df$discharge_disposition_id == 10] = "Neonate discharged to another hospital for neonatal aftercare"
df$discharge_disposition_id[df$discharge_disposition_id == 11] = "Expired"
df$discharge_disposition_id[df$discharge_disposition_id == 12] = "Still patient or expected to return for outpatient services"
df$discharge_disposition_id[df$discharge_disposition_id == 13] = "Hospice / home"
df$discharge_disposition_id[df$discharge_disposition_id == 14] = "Hospice / medical facility"
df$discharge_disposition_id[df$discharge_disposition_id == 15] = "Discharged/transferred within this institution to Medicare approved swing bed"
df$discharge_disposition_id[df$discharge_disposition_id == 16] = "Discharged/transferred/referred another institution for outpatient services"
df$discharge_disposition_id[df$discharge_disposition_id == 17] = "Discharged/transferred/referred to this institution for outpatient services"
df$discharge_disposition_id[df$discharge_disposition_id == 18] = "NULL"
df$discharge_disposition_id[df$discharge_disposition_id == 19] = "Expired at home. Medicaid only, hospice."
df$discharge_disposition_id[df$discharge_disposition_id == 20] = "Expired in a medical facility. Medicaid only, hospice."
df$discharge_disposition_id[df$discharge_disposition_id == 21] = "Expired, place unknown. Medicaid only, hospice."
df$discharge_disposition_id[df$discharge_disposition_id == 22] = "Discharged/transferred to another rehab fac including rehab units of a hospital."
df$discharge_disposition_id[df$discharge_disposition_id == 23] = "Discharged/transferred to a long term care hospital."
df$discharge_disposition_id[df$discharge_disposition_id == 24] = "Discharged/transferred to a nursing facility certified under Medicaid but not certified under Medicare."
df$discharge_disposition_id[df$discharge_disposition_id == 25] = "Not Mapped"
df$discharge_disposition_id[df$discharge_disposition_id == 26] = "Unknown/Invalid"
df$discharge_disposition_id[df$discharge_disposition_id == 27] = "Discharged/transferred to a federal health care facility."
df$discharge_disposition_id[df$discharge_disposition_id == 28] = "Discharged/transferred/referred to a psychiatric hospital of psychiatric distinct part unit of a hospital"
df$discharge_disposition_id[df$discharge_disposition_id == 29] = "Discharged/transferred to a Critical Access Hospital (CAH)."
df$discharge_disposition_id[df$discharge_disposition_id == 30] = "Discharged/transferred to another Type of Health Care Institution not Defined Elsewhere"

#combining unknown discharge types
df$discharge_disposition_id[df$discharge_disposition_id %in% c('NULL', 'Not Mapped')] = 'Unknown'

#table(df$discharge_disposition_id)

#relabeling admission source id

df$admission_source_id[df$admission_source_id == 1] = "Physician Referral"
df$admission_source_id[df$admission_source_id == 2] = "Clinic Referral"
df$admission_source_id[df$admission_source_id == 3] = "HMO Referral"
df$admission_source_id[df$admission_source_id == 4] = "Transfer from a hospital"
df$admission_source_id[df$admission_source_id == 5] = "Transfer from a Skilled Nursing Facility (SNF)"
df$admission_source_id[df$admission_source_id == 6] = "Transfer from another health care facility"
df$admission_source_id[df$admission_source_id == 7] = "Emergency Room"
df$admission_source_id[df$admission_source_id == 8] = "Court/Law Enforcement"
df$admission_source_id[df$admission_source_id == 9] = "Not Available"
df$admission_source_id[df$admission_source_id == 10] = "Transfer from critical access hospital"
df$admission_source_id[df$admission_source_id == 11] = "Normal Delivery"
df$admission_source_id[df$admission_source_id == 12] = "Premature Delivery"
df$admission_source_id[df$admission_source_id == 13] = "Sick Baby"
df$admission_source_id[df$admission_source_id == 14] = "Extramural Birth"
df$admission_source_id[df$admission_source_id == 15] = "Not Available"
df$admission_source_id[df$admission_source_id == 17] = "NULL"
df$admission_source_id[df$admission_source_id == 18] = "Transfer From Another Home Health Agency"
df$admission_source_id[df$admission_source_id == 19] = "Readmission to Same Home Health Agency"
df$admission_source_id[df$admission_source_id == 20] = "Not Mapped"
df$admission_source_id[df$admission_source_id == 21] = "Unknown/Invalid"
df$admission_source_id[df$admission_source_id == 22] = "Transfer from hospital inpt/same fac reslt in a sep claim"
df$admission_source_id[df$admission_source_id == 23] = "Born inside this hospital"
df$admission_source_id[df$admission_source_id == 24] = "Born outside this hospital"
df$admission_source_id[df$admission_source_id == 25] = "Transfer from Ambulatory Surgery Center"
df$admission_source_id[df$admission_source_id == 26] = "Transfer from Hospice"

#Combining unknown admission sources
df$admission_source_id[df$admission_source_id %in% c('Not Mapped', 'NULL', 'Not Available')] = 'Unknown'

#table(df$admission_source_id)

#relabeling admission type id

df$admission_type_id[df$admission_type_id == 1] = "Emergency"
df$admission_type_id[df$admission_type_id == 2] = "Urgent"
df$admission_type_id[df$admission_type_id == 3] = "Elective"
df$admission_type_id[df$admission_type_id == 4] = "Newborn"
df$admission_type_id[df$admission_type_id == 5] ="Not Available"
df$admission_type_id[df$admission_type_id == 6] = "NULL"
df$admission_type_id[df$admission_type_id == 7] = "Trauma Center"
df$admission_type_id[df$admission_type_id == 8] = "Not Mapped"

#Combining unknown admission types
df$admission_type_id[df$admission_type_id %in% c('Not Mapped', 'Not Available', 'NULL')] = 'Unknown'

#table(df$admission_type_id)

#relabeling and combining diag_1

df$diag_1[df$diag_1 >= 390 & df$diag_1 <= 459] = 'Circulatory'
df$diag_1[df$diag_1 == 785] = 'Circulatory'
df$diag_1[df$diag_1 >= 460 & df$diag_1 <= 519] = 'Respiratory'
df$diag_1[df$diag_1 == 786] = 'Respiratory'
df$diag_1[df$diag_1 >= 520 & df$diag_1 <= 579] = 'Digestive'
df$diag_1[df$diag_1 == 787] = 'Digestive'
df$diag_1[df$diag_1 >= 250 & df$diag_1 < 251] = 'Diabetes'
df$diag_1[df$diag_1 >= 800 & df$diag_1 <= 999] = 'Injury'
df$diag_1[df$diag_1 >= 710 & df$diag_1 <= 739] = 'Musculoskeletal'
df$diag_1[df$diag_1 >= 580 & df$diag_1 <= 629] = 'Genitourinary'
df$diag_1[df$diag_1 == 788] = 'Genitourinary'
df$diag_1[df$diag_1 >= 140 & df$diag_1 <= 239] = 'Neoplasms'
df$diag_1[df$diag_1 == 780] = 'Neoplasms'
df$diag_1[df$diag_1 == 781] = 'Neoplasms'
df$diag_1[df$diag_1 == 784] = 'Neoplasms'
df$diag_1[df$diag_1 >= 790 & df$diag_1 <= 799] = 'Neoplasms'
df$diag_1[df$diag_1 >= 240 & df$diag_1 < 250] = 'Neoplasms'
df$diag_1[df$diag_1 > 250 & df$diag_1 < 279] = 'Neoplasms'
df$diag_1[df$diag_1 > 680 & df$diag_1 < 709] = 'Neoplasms'
df$diag_1[df$diag_1 == 782] = 'Neoplasms'
df$diag_1[df$diag_1 > 001 & df$diag_1 < 139] = 'Neoplasms'
df$diag_1[df$diag_1 >= 290 & df$diag_1 < 319] = 'Mental Disorders'


#reassigning remaining values to zero (as this is essentially a "miscelaneous" category, and we are only concerned with high values

df$diag_1[df$diag_1 %!in% c('Circulatory', 'Respiratory', 'Digestive',
                            'Diabetes', 'Injury', 'Musculoskeletal', 'Genitourinary',
                            'Neoplasms', 'Mental Disorders')] = 0

#table(df$diag_1)

#relabeling and combining diag_2

df$diag_2[df$diag_2 >= 390 & df$diag_2 <= 459] = 'Circulatory'
df$diag_2[df$diag_2 == 785] = 'Circulatory'
df$diag_2[df$diag_2 >= 460 & df$diag_2 <= 519] = 'Respiratory'
df$diag_2[df$diag_2 == 786] = 'Respiratory'
df$diag_2[df$diag_2 >= 520 & df$diag_2 <= 579] = 'Digestive'
df$diag_2[df$diag_2 == 787] = 'Digestive'
df$diag_2[df$diag_2 >= 250 & df$diag_2 < 251] = 'Diabetes'
df$diag_2[df$diag_2 >= 800 & df$diag_2 <= 999] = 'Injury'
df$diag_2[df$diag_2 >= 710 & df$diag_2 <= 739] = 'Musculoskeletal'
df$diag_2[df$diag_2 >= 580 & df$diag_2 <= 629] = 'Genitourinary'
df$diag_2[df$diag_2 == 788] = 'Genitourinary'
df$diag_2[df$diag_2 >= 140 & df$diag_2 <= 239] = 'Neoplasms'
df$diag_2[df$diag_2 == 780] = 'Neoplasms'
df$diag_2[df$diag_2 == 781] = 'Neoplasms'
df$diag_2[df$diag_2 == 784] = 'Neoplasms'
df$diag_2[df$diag_2 >= 790 & df$diag_2 <= 799] = 'Neoplasms'
df$diag_2[df$diag_2 >= 240 & df$diag_2 < 250] = 'Neoplasms'
df$diag_2[df$diag_2 > 250 & df$diag_2 < 279] = 'Neoplasms'
df$diag_2[df$diag_2 > 680 & df$diag_2 < 709] = 'Neoplasms'
df$diag_2[df$diag_2 == 782] = 'Neoplasms'
df$diag_2[df$diag_2 > 001 & df$diag_2 < 139] = 'Neoplasms'
df$diag_2[df$diag_2 >= 290 & df$diag_2 < 319] = 'Mental Disorders'

#reassigning remaining values to zero (as this is essentially a "miscelaneous" category, and we are only concerned with high values

df$diag_2[df$diag_2 %!in% c('Circulatory', 'Respiratory', 'Digestive',
                            'Diabetes', 'Injury', 'Musculoskeletal', 'Genitourinary',
                            'Neoplasms', 'Mental Disorders')] = 0

#table(df$diag_2)

#relabeling and combining diag_3

df$diag_3[df$diag_3 >= 390 & df$diag_3 <= 459] = 'Circulatory'
df$diag_3[df$diag_3 == 785] = 'Circulatory'
df$diag_3[df$diag_3 >= 460 & df$diag_3 <= 519] = 'Respiratory'
df$diag_3[df$diag_3 == 786] = 'Respiratory'
df$diag_3[df$diag_3 >= 520 & df$diag_3 <= 579] = 'Digestive'
df$diag_3[df$diag_3 == 787] = 'Digestive'
df$diag_3[df$diag_3 >= 250 & df$diag_3 < 251] = 'Diabetes'
df$diag_3[df$diag_3 >= 800 & df$diag_3 <= 999] = 'Injury'
df$diag_3[df$diag_3 >= 710 & df$diag_3 <= 739] = 'Musculoskeletal'
df$diag_3[df$diag_3 >= 580 & df$diag_3 <= 629] = 'Genitourinary'
df$diag_3[df$diag_3 == 788] = 'Genitourinary'
df$diag_3[df$diag_3 >= 140 & df$diag_3 <= 239] = 'Neoplasms'
df$diag_3[df$diag_3 == 780] = 'Neoplasms'
df$diag_3[df$diag_3 == 781] = 'Neoplasms'
df$diag_3[df$diag_3 == 784] = 'Neoplasms'
df$diag_3[df$diag_3 >= 790 & df$diag_3 <= 799] = 'Neoplasms'
df$diag_3[df$diag_3 >= 240 & df$diag_3 < 250] = 'Neoplasms'
df$diag_3[df$diag_3 > 250 & df$diag_3 < 279] = 'Neoplasms'
df$diag_3[df$diag_3 > 680 & df$diag_3 < 709] = 'Neoplasms'
df$diag_3[df$diag_3 == 782] = 'Neoplasms'
df$diag_3[df$diag_3 > 001 & df$diag_3 < 139] = 'Neoplasms'
df$diag_2[df$diag_3 >= 290 & df$diag_3 < 319] = 'Mental Disorders'


#reassigning remaining values to zero (as this is essentially a "miscelaneous" category, and we are only concerned with high values

df$diag_3[df$diag_3 %!in% c('Circulatory', 'Respiratory', 'Digestive',
                            'Diabetes', 'Injury', 'Musculoskeletal', 'Genitourinary',
                            'Neoplasms', 'Mental Disorders')] = 0
#table(df$diag_3)

#redefining age column to nominal ordinal

df$age[df$age == "[0-10)"] = 0
df$age[df$age == "[10-20)"] = 1
df$age[df$age == "[20-30)"] = 2
df$age[df$age == "[30-40)"] = 3
df$age[df$age == "[40-50)"] = 4
df$age[df$age == "[50-60)"] = 5
df$age[df$age == "[60-70)"] = 6
df$age[df$age == "[70-80)"] = 7
df$age[df$age == "[80-90)"] = 8
df$age[df$age == "[90-100)"] = 9

#table(df$age)
#table(df$payer_code)

df1 = df

#removing those who expired
df1 = df1[!(df1$discharge_disposition_id == "Expired"),]
df1 = df1[!(df1$discharge_disposition_id == "Expired at home. Medicaid only, hospice."),]
df1 = df1[!(df1$discharge_disposition_id == "Expired in a medical facility. Medicaid only, hospice."),]
df1 = df1[!(df1$discharge_disposition_id == "Expired, place unknown. Medicaid only, hospice."),]

#renaming hyphenated drug columns for removal:

#y
#colnames(df1)[2] <- "newname2"

df2 = subset(df1, select = -c(encounter_id, patient_nbr, weight, payer_code, nateglinide, chlorpropamide, acetohexamide, tolbutamide,
                              acarbose, miglitol, troglitazone, tolazamide, examide, citoglipton, glyburide.metformin,
                              glipizide.metformin, metformin.rosiglitazone, metformin.pioglitazone, glimepiride.pioglitazone))

#DATA CLEANED TO APPROPRIATE DEGREE
#NOW ON TO DUMMIFICATION

#yy = colnames(df2)
#yy

#table(df$readmitted)

df_dums = select(df2, race, gender, admission_type_id, discharge_disposition_id, admission_source_id,
                 medical_specialty, diag_1, diag_2, diag_3, max_glu_serum, A1Cresult, metformin, repaglinide,
                 glimepiride, glipizide, glyburide, pioglitazone, rosiglitazone, insulin, change, diabetesMed, 
                 readmitted)

dumvars = fastDummies::dummy_cols(df_dums)

#colnames(dumvars)
#yyy

#table(df1$admission_source_id)

#REMOVED VARIABLES THAT WERE DUMMIFIED PREVIOUSLY, AND 1 COLUMN FROM EACH SERIES OF DUMMIFIED VARIABLE

dumvars2 = dumvars %>% select (-c('race', 'race_Other', 'gender', 'gender_Unknown/Invalid', 'admission_type_id',
                                  'admission_source_id', 'discharge_disposition_id',
                                  'insulin', 'metformin','medical_specialty',
                                  'diag_1', 'diag_2', 'diag_3', 'max_glu_serum', 'A1Cresult',
                                  'metformin', 'repaglinide', 'glimepiride', 'glipizide', 'glyburide', 
                                  'pioglitazone', 'rosiglitazone', 'change', 'diabetesMed','readmitted',
                                  'race_NA', 'gender_Female', 'admission_type_id_Newborn', 
                                  'discharge_disposition_id_Discharged/transferred to a federal health care facility.', 
                                  'medical_specialty_NA', 'diag_1_0','diag_2_0',
                                  'diag_3_0', 'A1Cresult_None', 'metformin_No','repaglinide_No', 'glimepiride_No',
                                  'glipizide_No', 'glyburide_No','pioglitazone_No', 'rosiglitazone_No', 'insulin_No',
                                  'change_No', 'diabetesMed_No','readmitted_NO'))

#REMOVED DUE TO LOW OCCURRENCE

dumvars2 = dumvars2 %>% select(-c('admission_type_id_Trauma Center', 'admission_source_id_Extramural Birth',
                                  'admission_source_id_Extramural Birth', 'admission_source_id_Normal Delivery', 
                                  'admission_source_id_Transfer from a Skilled Nursing Facility (SNF)',
                                  'admission_source_id_Transfer from Ambulatory Surgery Center',
                                  'admission_source_id_Transfer from critical access hospital',
                                  'admission_source_id_Transfer from hospital inpt/same fac reslt in a sep claim', 
                                  'discharge_disposition_id_Admitted as an inpatient to this hospital', 
                                  'discharge_disposition_id_Discharged/transferred to a long term care hospital.',
                                  'discharge_disposition_id_Discharged/transferred to a nursing facility certified under Medicaid but not certified under Medicare.',
                                  'discharge_disposition_id_Discharged/transferred to home under care of Home IV provider', 
                                  'discharge_disposition_id_Discharged/transferred within this institution to Medicare approved swing bed', 
                                  'discharge_disposition_id_Discharged/transferred/referred another institution for outpatient services',
                                  'discharge_disposition_id_Hospice / home', 'discharge_disposition_id_Hospice / medical facility', 
                                  'discharge_disposition_id_Hospice / medical facility','discharge_disposition_id_Left AMA', 
                                  'discharge_disposition_id_Neonate discharged to another hospital for neonatal aftercare', 
                                  'discharge_disposition_id_Still patient or expected to return for outpatient services',
                                  'medical_specialty_AllergyandImmunology', 'medical_specialty_Anesthesiology',
                                  'medical_specialty_Anesthesiology-Pediatric','medical_specialty_Cardiology-Pediatric', 
                                  'medical_specialty_DCPTEAM', 'medical_specialty_Dentistry', 
                                  'medical_specialty_Endocrinology','medical_specialty_Endocrinology-Metabolism', 
                                  'medical_specialty_Gynecology', 'medical_specialty_Hematology', 'medical_specialty_Hematology/Oncology',
                                  'medical_specialty_Hospitalist', 'medical_specialty_InfectiousDiseases', 'medical_specialty_Neurology',
                                  'medical_specialty_Neurophysiology', 'medical_specialty_Obsterics&Gynecology-GynecologicOnco', 
                                  'medical_specialty_Obstetrics', 'medical_specialty_ObstetricsandGynecology', 'medical_specialty_ObstetricsandGynecology',
                                  'medical_specialty_Oncology', 'medical_specialty_Ophthalmology', 'medical_specialty_Osteopath', 'medical_specialty_Otolaryngology', 
                                  'medical_specialty_OutreachServices', 'medical_specialty_Pathology', 'medical_specialty_Pediatrics',
                                  'medical_specialty_Pediatrics-EmergencyMedicine', 'medical_specialty_Pediatrics-Endocrinology', 
                                  'medical_specialty_Pediatrics-Hematology-Oncology', 
                                  'medical_specialty_Pediatrics-Neurology', 'medical_specialty_Pediatrics-Pulmonology', 'medical_specialty_Perinatology', 
                                  'medical_specialty_PhysicalMedicineandRehabilitation','medical_specialty_PhysicianNotFound', 'medical_specialty_Podiatry', 
                                  'medical_specialty_Proctology', 'medical_specialty_Psychiatry-Child/Adolescent', 
                                  'medical_specialty_Psychology', 'medical_specialty_Radiology', 'medical_specialty_Resident','medical_specialty_Rheumatology', 
                                  'medical_specialty_Surgeon', 'medical_specialty_Surgery-Cardiovascular',
                                  'medical_specialty_Surgery-Colon&Rectal', 'medical_specialty_Surgery-Maxillofacial', 'medical_specialty_Surgery-Neuro',
                                  'medical_specialty_Surgery-Pediatric', 'medical_specialty_Surgery-Thoracic', 
                                  'medical_specialty_Surgery-Vascular', 'medical_specialty_SurgicalSpecialty','medical_specialty_Urology',
                                  'admission_source_id_Court/Law Enforcement', 'medical_specialty_Speech'))


#Removing all non-numeric columns (i.e. those that were dummified) from the original data

df2_non_dum = subset(df2, select = -c(race, gender, admission_type_id, discharge_disposition_id, admission_source_id,
                                      medical_specialty, diag_1, diag_2, diag_3, max_glu_serum, A1Cresult, metformin, repaglinide,
                                      glimepiride, glipizide, glyburide, pioglitazone, rosiglitazone, insulin, change, diabetesMed, readmitted))

#Combining the finalized numeric, and dummified columns together, for filan dataset

df_FINAL = cbind(df2_non_dum, dumvars2)

#Exporting final dataset

write.csv(df_FINAL, file = "train_tim_12.1.csv")




#medical_specialty_ dummies with little values to be dropped


medical_specialty_Surgery-Colon&Rectal
medical_specialty_Surgery-Maxillofacial
medical_specialty_Surgery-Neuro
medical_specialty_Surgery-Pediatric
medical_specialty_Surgery-PlasticwithinHeadandNeck
medical_specialty_Surgery-Thoracic
medical_specialty_Surgery-Vascular
medical_specialty_SurgicalSpecialty
medical_specialty_Urology

medical_specialty_Pediatrics-Hematology-Oncology
medical_specialty_Pediatrics-InfectiousDiseases
medical_specialty_Pediatrics-Neurology
medical_specialty_Pediatrics-Pulmonology
medical_specialty_Perinatology
medical_specialty_PhysicalMedicineandRehabilitation
medical_specialty_PhysicianNotFound
medical_specialty_Podiatry
medical_specialty_Proctology
medical_specialty_Psychiatry-Addictive
medical_specialty_Psychiatry-Child/Adolescent
medical_specialty_Psychology
medical_specialty_Radiology
medical_specialty_Resident
medical_specialty_Rheumatology
medical_specialty_SportsMedicine
medical_specialty_Surgeon
medical_specialty_Surgery-Cardiovascular

table(df1$medical_specialty)

medical_specialty_AllergyandImmunology
medical_specialty_Anesthesiology
medical_specialty_Anesthesiology-Pediatric
medical_specialty_Cardiology-Pediatric 
medical_specialty_DCPTEAM
medical_specialty_Dentistry
medical_specialty_Dermatology
medical_specialty_Endocrinology
medical_specialty_Endocrinology-Metabolism
medical_specialty_Gynecology
medical_specialty_Hematology
medical_specialty_Hematology/Oncology
medical_specialty_Hospitalist
medical_specialty_InfectiousDiseases
medical_specialty_Neurology
medical_specialty_Neurophysiology
medical_specialty_Obsterics&Gynecology-GynecologicOnco
medical_specialty_Obstetrics
medical_specialty_ObstetricsandGynecology
medical_specialty_Oncology
medical_specialty_Ophthalmology
medical_specialty_Osteopath

medical_specialty_Otolaryngology
medical_specialty_OutreachServices
medical_specialty_Pathology

medical_specialty_Pediatrics
medical_specialty_Pediatrics-AllergyandImmunology
Pediatrics-EmergencyMedicine
medical_specialty_ediatrics-Endocrinology

medical_specialty_Pediatrics-Hematology-Oncology
medical_specialty_Pediatrics-InfectiousDiseases
medical_specialty_Pediatrics-Neurology
medical_specialty_Pediatrics-Pulmonology
medical_specialty_Perinatology
medical_specialty_PhysicalMedicineandRehabilitation
medical_specialty_PhysicianNotFound
medical_specialty_Podiatry
medical_specialty_Proctology
medical_specialty_Psychiatry-Addictive
medical_specialty_Psychiatry-Child/Adolescent
medical_specialty_Psychology
medical_specialty_Radiology
medical_specialty_Resident
medical_specialty_Rheumatology
medical_specialty_SportsMedicine
medical_specialty_Surgeon
medical_specialty_Surgery-Cardiovascular
medical_specialty_Surgery-Colon&Rectal
medical_specialty_Surgery-Maxillofacial
medical_specialty_Surgery-Neuro
medical_specialty_Surgery-Pediatric
medical_specialty_Surgery-PlasticwithinHeadandNeck
medical_specialty_Surgery-Thoracic
medical_specialty_Surgery-Vascular
medical_specialty_SurgicalSpecialty
medical_specialty_Urology

colnames(dumvars2)
#discharge_disposition_id dummies with little values to be dropped

table(df1$discharge_disposition_id)
discharge_disposition_id_Admitted as an inpatient to this hospital
discharge_disposition_id_Discharged/transferred to a long term care hospital.
discharge_disposition_id_Discharged/transferred to a nursing facility certified under Medicaid but not certified under Medicare. 
discharge_disposition_id_Discharged/transferred to home under care of Home IV provider
discharge_disposition_id_Discharged/transferred within this institution to Medicare approved swing bed 
discharge_disposition_id_Discharged/transferred/referred another institution for outpatient services 
discharge_disposition_id_Discharged/transferred/referred to a psychiatric hospital of psychiatric distinct part unit of a hospital
discharge_disposition_id_Discharged/transferred/referred to this institution for outpatient services
discharge_disposition_id_Hospice / home 
discharge_disposition_id_Hospice / medical facility 
discharge_disposition_id_Left AMA
Neonate discharged to another hospital for neonatal aftercare
Still patient or expected to return for outpatient services 


table(df1$admission_type_id)
admission_type_id_Trauma Center

#admission_source_id dummies with little values to be dropped
table(df1$admission_source_id)
admission_source_id_Extramural Birth
admission_source_id_HMO Referral
admission_source_id_Normal Delivery
admission_source_id_Transfer from a Skilled Nursing Facility (SNF)
admission_source_id_Transfer from Ambulatory Surgery Center
admission_source_id_Transfer from critical access hospital
admission_source_id_Transfer from hospital inpt/same fac reslt in a sep claim
, '', '', '','', '', '', '', '','', '', '', '',
                               






