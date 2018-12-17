#Define your input parameters here

#True Positive rate -- (based on confusion matrix of test data)
TP_rate = 0.59
#False Positive rate -- (based on confusion matrix of test data)
FP_rate = 0.16
#readmission rate -- (based on the readmission experience of our data, or through literature review)
Readmitted_rate = 0.1
#the size patient population being assessed
Patient_population = 100000
#average stay cost, based off of length of stay (average 4.5 days from our data) and ~$10,000 per day for hospital admission
Average_stay_cost = 45000
#average percentage of readmissions reduced via Diabetes Management plan, derived from literature review
Average_prog_readmi_perc_drop = 0.5
#average per-patient cost of Diabetes Management Plan, based on projections of physician, discharge nurse, and home visiting nurse's time
Diabetes_mgmt_cost = 500

params = c(.59,.16,.1,100000,45000,.5,500)

drp = function(TP_rate = .59,
               FP_rate = .16,
               Readmitted_rate = .1,
               Patient_population = 100000,
               Average_days = 4.5,
               Average_cost_per_day = 10000,
               Average_prog_readmi_perc_drop = .5,
               Diabetes_mgmt_cost = 500) {
  Not_readmitted = (1 - Readmitted_rate) * Patient_population
  Readmitted = Readmitted_rate * Patient_population
  True_Positives = TP_rate * Readmitted
  False_Positives = FP_rate * Not_readmitted
  Average_stay_cost = Average_days * Average_cost_per_day
  Old_total_expense = Readmitted_rate * Average_stay_cost * Patient_population
  New_readmission_expense = Average_stay_cost * (Readmitted - (True_Positives * Average_prog_readmi_perc_drop))
  difference_in_total_expense = Old_total_expense - New_readmission_expense
  new_readmission_rate = Readmitted_rate - (Readmitted_rate * TP_rate * Average_prog_readmi_perc_drop)
  difference_in_readmission_rates = Readmitted_rate - new_readmission_rate
  percent_drop_in_readmission_rates = difference_in_readmission_rates / Readmitted_rate
  difference_in_total_expense_per_patient = difference_in_total_expense / Patient_population
  values2 = format(c(difference_in_total_expense,difference_in_total_expense_per_patient,
                     difference_in_readmission_rates, percent_drop_in_readmission_rates),scientific = F)
  results = c(paste0("Total Savings: ",values2[1]),paste0("Average Savings Per Patient: ",values2[2]),
              paste0("Reduction in Readmission Rate: ",values2[3]), paste0("Percent Reduction in Readmission Rate: ",values2[4]))
  return(results)
}

drp()













Diabetes_Readmission_Predictor = function(TP_rate,
                                          FP_rate,
                                          Readmitted_rate,
                                          Patient_population,
                                          Average_stay_cost,
                                          Average_prog_readmi_perc_drop,
                                          Diabetes_mgmt_cost) 
# calculate the number of patients NOT readmitted
Not_readmitted = (1 - Readmitted_rate) * Patient_population
  
# calculate the number of patients readmitted
Readmitted = Readmitted_rate * Patient_population
  
# calculate the number of TRUE Positives (i.e. those we correctly predicted would be readmitted)
True_Positives = TP_rate * Readmitted
  
# calculate the number of FALSE Positives (those we predicted would be readmitted, but actually would not have been)
False_Positives = FP_rate * Not_readmitted
  
#calculate old program expense
Old_total_expense = Readmitted_rate * Average_stay_cost * Patient_population
  
#calculate expense of readmission after implimenting DM program
  
New_readmission_expense = Average_stay_cost * (Readmitted - (True_Positives * Average_prog_readmi_perc_drop))
  
#calculate the savings in total expense resulting from switching between the old program -- and the DM program
  
difference_in_total_expense =  Old_total_expense - New_readmission_expense
  
#calculate the new readmission rate under the DM program
  
new_readmission_rate = Readmitted_rate - (Readmitted_rate * TP_rate * Average_prog_readmi_perc_drop)
  
#calculate the drop in readmission rates
  
difference_in_readmission_rates = Readmitted_rate - new_readmission_rate
  
#calculate the percentage reduction in readmission rates
  
percent_drop_in_readmission_rates = difference_in_readmission_rates / Readmitted_rate
  
  
  
#calculate the difference in total expense per patient
  
difference_in_total_expense_per_patient = difference_in_total_expense / Patient_population
values2 = c(difference_in_total_expense, difference_in_total_expense_per_patient)
  
return(paste("Total Savings:",values2[1],paste("Average Savings Per Patient:",values2[2])))


#  return(temp_K)
#}


# # calculate the number of patients NOT readmitted
# Not_readmitted = (1 - Readmitted_rate) * Patient_population
# # calculate the number of patients readmitted
# Readmitted = Readmitted_rate * Patient_population
# # calculate the number of TRUE Positives (i.e. those we correctly predicted would be readmitted)
# True_Positives = TP_rate * Readmitted
# # calculate the number of FALSE Positives (those we predicted would be readmitted, but actually would not have been)
# False_Positives = FP_rate * Not_readmitted 
# # calculate the number of readmissions prevented due to implementing the Diabetes Management plan
# Readmi_prevented = Average_prog_readmi_perc_drop * True_Positives
# # calculate the dollars saved from the readmissions prevented due to implementing the Diabetes Management plan    
# Readmi_savings = Readmi_prevented * Average_stay_cost
# # calculate the total cost of the Diabetes Management plan, for all of the Positives (i.e. True AND False positives)
# Diabetes_mgmt_cost_total = Diabetes_mgmt_cost * (True_Positives + False_Positives)
# # calculate the difference between the total savings on readmission -- and total expenditure on Diabetes Management plan
# Net_savings = Readmi_savings - Diabetes_mgmt_cost
# # calculate the average savings on a per-patient basis
# Net_savings_per_patient = Net_savings/Patient_population
# 
# values = (Net_savings_per_patient, Net_savings, Readmi_savings, Diabetes_mgmt_cost_total, True_Positives, False_Positives)
# print(values)
# 
# 
