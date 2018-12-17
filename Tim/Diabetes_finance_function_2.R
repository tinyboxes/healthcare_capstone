#Define parameters:

drp = function(True_positive_rate = .59,
               #True Positive rate -- (based on confusion matrix of test data)
               False_positive_rate = .16,
               #FP_rate = False Positive rate -- (based on confusion matrix of test data)
               Readmission_rate = .1,
               #readmission rate -- (based on the readmission experience of our data, or through literature review)
               Patient_population = 100000,
               #the size patient population being assessed
               Average_days = 4.5,
               #average length of inpatient stay due to readmission
               Average_cost_per_day = 10000,
               #average daily cost of inpatient stay
               Average_prog_readmi_perc_drop = .5,
               #average percentage of readmissions reduced once the Diabetes Management plan is implimented, derived from literature review
               Diabetes_mgmt_cost = 500) 
               #average per-patient cost of Diabetes Management Plan, based on projections of physician, discharge nurse, and home visiting nurse's time

{
  Not_readmitted = (1 - Readmission_rate) * Patient_population
  # calculate the number of patients NOT readmitted
  
  Readmitted = Readmission_rate * Patient_population
  # calculate the number of patients readmitted
  
  True_Positives = True_positive_rate * Readmitted
  # calculate the number of TRUE Positives (i.e. those we correctly predicted would be readmitted)
  
  False_Positives = False_positive_rate * Not_readmitted
  # calculate the number of FALSE Positives (those we predicted would be readmitted, but actually would not have been)
  
  Average_stay_cost = Average_days * Average_cost_per_day
  #calculate the readmission cost based on the rate per day and the number of days
  
  #calculate how much money the new program saves
  Savings_on_Readmissions = (Average_stay_cost * True_Positives * Average_prog_readmi_perc_drop)
  
  #calculate the additional expense of implimenting the program
  Expense_of_diabetes_program = (Diabetes_mgmt_cost * (True_Positives + False_Positives))
  
  #calculate the net savings of the program
  Total_savings_of_program = Savings_on_Readmissions - Expense_of_diabetes_program
  
  #calculate the savings in total expense resulting from switching between the old program -- and the DM program -- on a per-patient basis
  Savings_of_Program_per_patient = Total_savings_of_program / Patient_population

  #new_readmission_rate = (Readmission_rate * True_positive_rate * Average_prog_readmi_perc_drop)
  new_readmission_rate = Readmission_rate - (Readmission_rate * True_positive_rate * Average_prog_readmi_perc_drop)
  #calculate the new readmission rate under the Diabetes Management program
  
  difference_in_readmission_rates = Readmission_rate - new_readmission_rate
  #calculate the drop in readmission rates due to the Diabetes Management program is implimented
  
  percent_drop_in_readmission_rates = (difference_in_readmission_rates / Readmission_rate) * 100
  #calculate the percentage reduction in readmission rates due to the Diabetes Management program
  
  #difference_in_total_expense_per_patient = difference_in_total_expense / Patient_population
  #calculate the savings in total expense resulting from switching between the old program -- and the DM program -- on a per-patient basis
  
  values2 = format(c(Total_savings_of_program,Savings_of_Program_per_patient,
                     difference_in_readmission_rates, percent_drop_in_readmission_rates),scientific = F)
  
  results = c(paste0("Total Savings: ",values2[1]),paste0("Average Savings Per Patient: ",values2[2]),
              paste0("Reduction in Readmission Rate: ",values2[3]), paste0("Percent Reduction in Readmission Rate: ",values2[4]))
  
  return(results)
}

drp()



