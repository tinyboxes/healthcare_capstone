
import pandas as pd
import numpy as np
import math

#load the initial data file:
diabetes = pd.read_csv('./Denisediabetic_data.csv')

#Examine the initial data file:
diabetes.head()

In [143]:
#Rewrite the 24 medication columns to make clearer that they are all comparing the same thing:

Dcolumns = list(diabetes.columns)
for i in range(24, 47):
    Dcolumns[i] = "med_" + Dcolumns[i]
Dcolumns[48] = "med_any"

diabetes.columns = Dcolumns

#age is strictly divided into decades of life. We should make this numeric for now:
diabetes['age'].value_counts()
diabetes['age'] = diabetes['age'].replace(['[0-10)', '[10-20)', '[20-30)', '[30-40)', '[40-50)', '[50-60)',
                                              '[60-70)', '[70-80)', '[80-90)', '[90-100)'], [1,2,3,4,5,6,7,8,9,10])

# '''Some patients show up multiple times in the analysis. This certainly might be relevant,
# but it is covered in other features (num_outpatient, num_inpatient, etc). We should remove encounter_id and patient_nbr.'''
diabetes['patient_nbr'].value_counts(10)
diabetes = diabetes.drop(['encounter_id', 'patient_nbr'], axis=1)

diabetes.head()

#Race has a ? variable, which we need to keep track of for now (will address/impute later):
diabetes['race'].value_counts()
FeaturesWithMissing = ['race']

#Gender has an Unknown variable also, with only three values. Let's see what these look like:
diabetes['gender'].value_counts()

#Examine in more detail some info from these 3 gender-unknown patients.
diabetes[diabetes['gender']=='Unknown/Invalid']
print(diabetes.iloc[30506,])
print(diabetes.iloc[75551,])
print(diabetes.iloc[82573,])

#These three patients are gender-unknown, race unknown or other. I would recommend removing these values as gender and race seem relevant, and it's only 3 data points, and honestly, if the doctor couldn't fill in gender, I'm not even sure I would believe readmited='NO'.

diabetes = diabetes.drop([30506, 75551, 82573], axis=0)
diabetes.index = list(range(len(diabetes)))
diabetes['gender'].value_counts()

#97% of data on weight is missing. We can not do anything with this, particularly because it could be non-random. Remove this variable:
diabetes = diabetes.drop(['weight'], axis=1)

#Admission types look OK, except that 8 and 6 are the same. We should combine them:
diabetes['admission_type_id'].value_counts()
diabetes['admission_type_id'] = diabetes['admission_type_id'].replace([8], [6])

# These need some adjusting. 11, 19, 20, 21 mean the patient died. Clearly, readmission rates will be 0 here, and this could \
# be written into an algorithm, but for now, they should certainly be rewritten as the same thing.
# 18, 25, and 26 are all the same thing also (unknown).'''

diabetes['discharge_disposition_id'].value_counts()

#Write to csv to visualize in ggplot2, a far superior visualization tool:
#diabetes.to_csv('diabetesmod.csv')



#### visualization

# '''After visualization, and careful reading of the descriptions, I would rewrite the 30 discharge categories.'''
replacelist = ['home', 'hospital', 'nursing', 'nursing', 'hospice', 'hhealth', 'leftAMA', 'hhealth', 'hospital', 'hospital',
              'died', 'hospital', 'hospice', 'hospice', 'hospital', 'outpatient', 'outpatient', 'unknown', 'died', 'died',
              'died', 'outpatient', 'hospital', 'nursing', 'unknown', 'unknown', 'nursing', 'psych', 'hospital', 'outpatient']

diabetes['discharge_disposition_id'] = diabetes['discharge_disposition_id'].replace(list(range(1,31)), replacelist)

diabetes['discharge_disposition_id'].value_counts()


#Rewrite the column as discharge disposition:
newcollist = list(diabetes.columns)
newcollist[newcollist.index('discharge_disposition_id')]='discharge_disposition'
diabetes.columns = newcollist

diabetes['admission_source_id'].value_counts()

#There are no missing values in the "time in hospital"
print(sum(diabetes['time_in_hospital'].isna()))
print(diabetes['time_in_hospital'].describe())


#For now, we can keep payer_code, although there are a large number of missing values and this feature would not seem to be important
diabetes['payer_code'].value_counts()

#This category is completely unwieldy, and we will have to figure out what to do with this too. It has 40% missing values:
diabetes['medical_specialty'].value_counts()

#Num_lab_procedures is clear
print(diabetes['num_lab_procedures'].describe())
sum(diabetes['num_lab_procedures'].isna())


#Num_procedures is also clear:
print(diabetes['num_procedures'].describe())
sum(diabetes['num_procedures'].isna())

#Num_medications is also clear:
print(diabetes['num_medications'].describe())
sum(diabetes['num_medications'].isna())

#Num_outpatient is also clear:
print(diabetes['number_outpatient'].describe())
sum(diabetes['number_outpatient'].isna())

#Num_emergency is also clear:
print(diabetes['number_emergency'].describe())
sum(diabetes['number_emergency'].isna())

#Num_inpatient is also clear:
print(diabetes['number_inpatient'].describe())
sum(diabetes['number_inpatient'].isna())

#Num_diagnoses is also clear:
print(diabetes['number_diagnoses'].describe())
sum(diabetes['number_diagnoses'].isna())

# '''Num_diagnoses and diag_1/diag_2/diag_3 are highly related to each other. If num_diagnoses are 3 or under, diag_3 (and
# diag_2) will be empty. A "primary" diagnosis is essentially what the patient is in there for. Secondary diagnoses are other
# things the patient has. I would recommend combining diag_1 thru diag_3 together'''

#Max glucose in serum is present, though many points were not measured. We should rewrite these as "NotTaken"
diabetes['max_glu_serum'].value_counts()
diabetes['max_glu_serum'] = diabetes['max_glu_serum'].replace(['None'], ['NotTaken'])

#Same story for A1C measurement
diabetes['A1Cresult'].value_counts()
diabetes['A1Cresult'] = diabetes['A1Cresult'].replace(['None'], ['NotTaken'])

#Write a function to rewrite the disease codes according to a modified version of the publication:
def convertdiseases(min, max, newname):
    d1 = diabetes['diag_1'].tolist()
    d2 = diabetes['diag_2'].tolist()
    d3 = diabetes['diag_3'].tolist()

    for i in range(len(d1)):
        try:
            if float(d1[i]) >= min and float(d1[i]) < max:
                d1[i] = newname
        except:
            pass
        try:
            if float(d2[i]) >= min and float(d2[i]) < max:
                d2[i] = newname
        except:
            pass
        try:
            if float(d3[i]) >= min and float(d3[i]) < max:
                d3[i] = newname
        except:
            pass

    diabetes['diag_1'] = pd.Series(d1)
    diabetes['diag_2'] = pd.Series(d2)
    diabetes['diag_3'] = pd.Series(d3)

convertdiseases(340, 459, 'circulatory')

#That worked pretty well. Let's do this for all additional values and combinations:
diabetes['diag_1'].value_counts()

convertdiseases(785, 786, 'circulatory')
convertdiseases(745, 748, 'circulatory')
convertdiseases(459, 460, 'circulatory')
convertdiseases(460, 520, 'respiratory')
convertdiseases(786, 787, 'respiratory')
convertdiseases(748, 749, 'respiratory')
convertdiseases(520, 580, 'digestive')
convertdiseases(787, 788, 'digestive')
convertdiseases(749, 752, 'digestive')
convertdiseases(800, 1000, 'injury')
convertdiseases(710, 740, 'musculoskeletal')
convertdiseases(754, 757, 'musculoskeletal')
convertdiseases(580, 630, 'urogenital')
convertdiseases(788, 789, 'urogenital')
convertdiseases(752, 754, 'urogenital')
convertdiseases(140, 240, 'neoplasm')
convertdiseases(1, 140, 'infection')
convertdiseases(290, 320, 'mentaldis')
convertdiseases(280, 290, 'blooddis')
convertdiseases(320, 360, 'nervous')
convertdiseases(360, 390, 'nervous')
convertdiseases(740, 743, 'nervous')
convertdiseases(630, 680, 'pregnancy')
convertdiseases(780, 782, 'other')
convertdiseases(784, 785, 'other')
convertdiseases(790, 800, 'other')
convertdiseases(743, 745, 'other')
convertdiseases(757, 760, 'other')

# '''This successfully converted our targets. Now we still have things to convert. All patients have diabetes, so the 250
# classifications are not important insofar as they diagnose diabetes. We can, however, glean addition diabetic info from the
# decimal codes, where they exist. They would need to go to their own categories, however.'''

# '''First, lets get rid of the EV codes, which the publication refers to as injuries or additional diagnosic information'''
diabetes['diag_1'].value_counts()


diabetes['diag_1'] = diabetes['diag_1'].replace('V[0-9]+', 'injury', regex=True)
diabetes['diag_1'] = diabetes['diag_1'].replace('E[0-9]+', 'injury', regex=True)
diabetes['diag_2'] = diabetes['diag_2'].replace('V[0-9]+', 'injury', regex=True)
diabetes['diag_2'] = diabetes['diag_2'].replace('E[0-9]+', 'injury', regex=True)
diabetes['diag_3'] = diabetes['diag_3'].replace('V[0-9]+', 'injury', regex=True)
diabetes['diag_3'] = diabetes['diag_3'].replace('E[0-9]+', 'injury', regex=True)

#This is looking better, but apprently, some ICD-9 codes weren't covered in our initial conversion:
diabetes['diag_1'].value_counts()

convertdiseases(240, 250, 'metabolic')
convertdiseases(251, 280, 'metabolic')
convertdiseases(680, 710, 'skin')
convertdiseases(782, 783, 'skin')

#All that is missing now is 783, 789
diabetes['diag_1'].value_counts()

convertdiseases(789, 790, 'other')
convertdiseases(783, 784, 'metabolic')

# '''We now have all values, other than ? and the diabetes codes, as a category. Let's create a new column with additional
# diabetes info (from the 250 codes), then revert all 250's and ? to 'NoDisease', a value which will go away after diag1, 2, 3
# combination.'''

#We can create 4 rows (eventually condensed to 2): diabetes_feature (1-3) and Type (1 or 2):

#Write a function to migrate data from diabetes codes to new columns, then revert them to "NoDisease":
# '''This function returns a modified version of our DF, and creates four rows. diabfeature1, 2, 3 which are extra diabetic
# features of the patient, and diabtype which is a report of either Type1, Type2, or (typically) unknown for the patient,
# based on ICD code'''
def convertdiabetescodes(df):
    df2 = df.copy()
    d1 = list(df2['diag_1'])
    d2 = list(df2['diag_2'])
    d3 = list(df2['diag_3'])

    f1 = []
    f2 = []
    f3 = []
    diabtype1 = []
    diabtype2 = []
    diabtype3 = []

    for i in range(len(d1)):
        try:

            if 100*float(d1[i]) % 10 == 1 or 100*float(d1[i]) % 10 == 3:
                diabtype1.append('Type1')
            elif 100*float(d1[i]) % 10 == 2:
                diabtype1.append('Type2')
            elif 100*float(d1[i]) % 10 == 0:
                diabtype1.append('Unknown')
            else:
                diabtype1.append('Unknown')

            if 100*float(d1[i]) % 100 >= 10 and 100*float(d1[i]) % 100 < 20:
                f1.append('ketoacidosis')
            elif 100*float(d1[i]) % 100 >= 20 and 100*float(d1[i]) % 100 < 30:
                f1.append('hyperosmolarity')
            elif 100*float(d1[i]) % 100 >= 30 and 100*float(d1[i]) % 100 < 40:
                f1.append('coma')
            elif 100*float(d1[i]) % 100 >= 40 and 100*float(d1[i]) % 100 < 50:
                f1.append('renal')
            elif 100*float(d1[i]) % 100 >= 50 and 100*float(d1[i]) % 100 < 60:
                f1.append('ophthalmic')
            elif 100*float(d1[i]) % 100 >= 60 and 100*float(d1[i]) % 100 < 70:
                f1.append('neurologic')
            elif 100*float(d1[i]) % 100 >= 70 and 100*float(d1[i]) % 100 < 80:
                f1.append('circulatory')
            elif 100*float(d1[i]) % 100 >= 80:
                f1.append('other')
            elif 100*float(d1[i]) % 100 >=0 and 100*float(d1[i]) % 100 < 10:
                f1.append('No')
            else:
                f1.append('No')

        except:
            diabtype1.append('No')
            f1.append('No')

        try:
            if 100*float(d2[i]) % 10 == 1 or 100*float(d2[i]) % 10 == 3:
                diabtype2.append('Type1')
            elif 100*float(d2[i]) % 10 == 2:
                diabtype2.append('Type2')
            elif 100*float(d2[i]) % 10 == 0:
                diabtype2.append('Unknown')
            else:
                diabtype2.append('Unknown')

            if 100*float(d2[i]) % 100 >= 10 and 100*float(d2[i]) % 100 < 20:
                f2.append('ketoacidosis')
            elif 100*float(d2[i]) % 100 >= 20 and 100*float(d2[i]) % 100 < 30:
                f2.append('hyperosmolarity')
            elif 100*float(d2[i]) % 100 >= 30 and 100*float(d2[i]) % 100 < 40:
                f2.append('coma')
            elif 100*float(d2[i]) % 100 >= 40 and 100*float(d2[i]) % 100 < 50:
                f2.append('renal')
            elif 100*float(d2[i]) % 100 >= 50 and 100*float(d2[i]) % 100 < 60:
                f2.append('ophthalmic')
            elif 100*float(d2[i]) % 100 >= 60 and 100*float(d2[i]) % 100 < 70:
                f2.append('neurologic')
            elif 100*float(d2[i]) % 100 >= 70 and 100*float(d2[i]) % 100 < 80:
                f2.append('circulatory')
            elif 100*float(d2[i]) % 100 >= 80:
                f2.append('other')
            elif 100*float(d2[i]) % 100 >=0 and 100*float(d2[i]) % 100 < 10:
                f2.append('No')
            else:
                f2.append('No')

        except:
            diabtype2.append('No')
            f2.append('No')

        try:
            if 100*float(d3[i]) % 10 == 1 or 100*float(d3[i]) % 10 == 3:
                diabtype3.append('Type1')
            elif 100*float(d3[i]) % 10 == 2:
                diabtype3.append('Type2')
            elif 100*float(d3[i]) % 10 == 0:
                diabtype3.append('Unknown')
            else:
                diabtype3.append('Unknown')

            if 100*float(d3[i]) % 100 >= 10 and 100*float(d3[i]) % 100 < 20:
                f3.append('ketoacidosis')
            elif 100*float(d3[i]) % 100 >= 20 and 100*float(d3[i]) % 100 < 30:
                f3.append('hyperosmolarity')
            elif 100*float(d3[i]) % 100 >= 30 and 100*float(d3[i]) % 100 < 40:
                f3.append('coma')
            elif 100*float(d3[i]) % 100 >= 40 and 100*float(d3[i]) % 100 < 50:
                f3.append('renal')
            elif 100*float(d3[i]) % 100 >= 50 and 100*float(d3[i]) % 100 < 60:
                f3.append('ophthalmic')
            elif 100*float(d3[i]) % 100 >= 60 and 100*float(d3[i]) % 100 < 70:
                f3.append('neurologic')
            elif 100*float(d3[i]) % 100 >= 70 and 100*float(d3[i]) % 100 < 80:
                f3.append('circulatory')
            elif 100*float(d3[i]) % 100 >= 80:
                f3.append('other')
            elif 100*float(d3[i]) % 100 >=0 and 100*float(d3[i]) % 100 < 10:
                f3.append('No')
            else:
                f3.append('No')

        except:
            diabtype3.append('No')
            f3.append('No')

    finaltype = []

    for i in range(len(diabtype1)):
        if diabtype1 == 'Type1' or diabtype2 == 'Type1' or diabtype3 == 'Type1':
            finaltype.append('Type1')
        elif diabtype1 == 'Type2' or diabtype2 == 'Type2' or diabtype3 == 'Type2':
            finaltype.append('Type2')
        else:
            finaltype.append('Unknown')

    df2['diabfeature1'] = f1
    df2['diabfeature2'] = f2
    df2['diabfeature3'] = f3
    df2['diabtype'] = finaltype

    return df2

#We can create 4 rows (eventually condensed to 2): diabetes_feature (1-3) and Type (1 or 2):

#Write a function to migrate data from diabetes codes to new columns, then revert them to "NoDisease":
# '''This function returns a modified version of our DF, and creates four rows. diabfeature1, 2, 3 which are extra diabetic
# features of the patient, and diabtype which is a report of either Type1, Type2, or (typically) unknown for the patient,
# based on ICD code'''
def convertdiabetescodes(df):
    df2 = df.copy()
    d1 = list(df2['diag_1'])
    d2 = list(df2['diag_2'])
    d3 = list(df2['diag_3'])

    f1 = []
    f2 = []
    f3 = []
    diabtype1 = []
    diabtype2 = []
    diabtype3 = []

    for i in range(len(d1)):
        try:

            if int(100*float(d1[i])) % 10 == 1 or int(100*float(d1[i])) % 10 == 3:
                diabtype1.append('Type1')
            elif int(100*float(d1[i])) % 10 == 2:
                diabtype1.append('Type2')
            elif int(100*float(d1[i])) % 10 == 0:
                diabtype1.append('Unknown')
            else:
                diabtype1.append('Unknown')

            if int(100*float(d1[i])) % 100 >= 10 and int(100*float(d1[i])) % 100 < 20:
                f1.append('ketoacidosis')
            elif int(100*float(d1[i])) % 100 >= 20 and int(100*float(d1[i])) % 100 < 30:
                f1.append('hyperosmolarity')
            elif int(100*float(d1[i])) % 100 >= 30 and int(100*float(d1[i])) % 100 < 40:
                f1.append('coma')
            elif int(100*float(d1[i])) % 100 >= 40 and int(100*float(d1[i])) % 100 < 50:
                f1.append('renal')
            elif int(100*float(d1[i])) % 100 >= 50 and int(100*float(d1[i])) % 100 < 60:
                f1.append('ophthalmic')
            elif int(100*float(d1[i])) % 100 >= 60 and int(100*float(d1[i])) % 100 < 70:
                f1.append('neurologic')
            elif int(100*float(d1[i])) % 100 >= 70 and int(100*float(d1[i])) % 100 < 80:
                f1.append('circulatory')
            elif int(100*float(d1[i])) % 100 >= 80:
                f1.append('other')
            elif int(100*float(d1[i])) % 100 >=0 and int(100*float(d1[i])) % 100 < 10:
                f1.append('No')
            else:
                f1.append('No')

        except:
            diabtype1.append('No')
            f1.append('No')

        try:
            if int(100*float(d2[i])) % 10 == 1 or int(100*float(d2[i])) % 10 == 3:
                diabtype2.append('Type1')
            elif int(100*float(d2[i])) % 10 == 2:
                diabtype2.append('Type2')
            elif int(100*float(d2[i])) % 10 == 0:
                diabtype2.append('Unknown')
            else:
                diabtype2.append('Unknown')

            if int(100*float(d2[i])) % 100 >= 10 and int(100*float(d2[i])) % 100 < 20:
                f2.append('ketoacidosis')
            elif int(100*float(d2[i])) % 100 >= 20 and int(100*float(d2[i])) % 100 < 30:
                f2.append('hyperosmolarity')
            elif int(100*float(d2[i])) % 100 >= 30 and int(100*float(d2[i])) % 100 < 40:
                f2.append('coma')
            elif int(100*float(d2[i])) % 100 >= 40 and int(100*float(d2[i])) % 100 < 50:
                f2.append('renal')
            elif int(100*float(d2[i])) % 100 >= 50 and int(100*float(d2[i])) % 100 < 60:
                f2.append('ophthalmic')
            elif int(100*float(d2[i])) % 100 >= 60 and int(100*float(d2[i])) % 100 < 70:
                f2.append('neurologic')
            elif int(100*float(d2[i])) % 100 >= 70 and int(100*float(d2[i])) % 100 < 80:
                f2.append('circulatory')
            elif int(100*float(d2[i])) % 100 >= 80:
                f2.append('other')
            elif int(100*float(d2[i])) % 100 >=0 and int(100*float(d2[i])) % 100 < 10:
                f2.append('No')
            else:
                f2.append('No')

        except:
            diabtype2.append('No')
            f2.append('No')

        try:
            if int(100*float(d3[i])) % 10 == 1 or int(100*float(d3[i])) % 10 == 3:
                diabtype3.append('Type1')
            elif int(100*float(d3[i])) % 10 == 2:
                diabtype3.append('Type2')
            elif int(100*float(d3[i])) % 10 == 0:
                diabtype3.append('Unknown')
            else:
                diabtype3.append('Unknown')

            if int(100*float(d3[i])) % 100 >= 10 and int(100*float(d3[i])) % 100 < 20:
                f3.append('ketoacidosis')
            elif int(100*float(d3[i])) % 100 >= 20 and int(100*float(d3[i])) % 100 < 30:
                f3.append('hyperosmolarity')
            elif int(100*float(d3[i])) % 100 >= 30 and int(100*float(d3[i])) % 100 < 40:
                f3.append('coma')
            elif int(100*float(d3[i])) % 100 >= 40 and int(100*float(d3[i])) % 100 < 50:
                f3.append('renal')
            elif int(100*float(d3[i])) % 100 >= 50 and int(100*float(d3[i])) % 100 < 60:
                f3.append('ophthalmic')
            elif int(100*float(d3[i])) % 100 >= 60 and int(100*float(d3[i])) % 100 < 70:
                f3.append('neurologic')
            elif int(100*float(d3[i])) % 100 >= 70 and int(100*float(d3[i])) % 100 < 80:
                f3.append('circulatory')
            elif int(100*float(d3[i])) % 100 >= 80:
                f3.append('other')
            elif int(100*float(d3[i])) % 100 >=0 and int(100*float(d3[i])) % 100 < 10:
                f3.append('No')
            else:
                f3.append('No')

        except:
            diabtype3.append('No')
            f3.append('No')

    finaltype = []

    for i in range(len(diabtype1)):
        if diabtype1[i] == 'Type1' or diabtype2[i] == 'Type1' or diabtype3[i] == 'Type1':
            finaltype.append('Type1')
        elif diabtype1[i] == 'Type2' or diabtype2[i] == 'Type2' or diabtype3[i] == 'Type2':
            finaltype.append('Type2')
        else:
            finaltype.append('Unknown')

    df2['diabfeature1'] = f1
    df2['diabfeature2'] = f2
    df2['diabfeature3'] = f3
    df2['diabtype'] = finaltype

    return df2

#Now, let's update diabetes to diabetes02 with these extra columns:
diabetes02 = convertdiabetescodes(diabetes)

#Now, we can see that we have Type1/2 information for some of the patients.
diabetes02['diabtype'].value_counts()

#We can also see supplementary diabeteic features for these patients based on the code presented:
diabetes02['diabfeature1'].value_counts()

#Save file and reopen:

diabetes02.to_csv('diabetes02.csv')
diabetes02 = pd.read_csv('diabetes02.csv', index_col=0)

#Let's see if we can impute additional columns for Type1/Type2 based on what we have here
diabetes00 = pd.read_csv('./Denise/diabetic_data.csv')

diabetes00['diabtype'] = diabetes02['diabtype']

# '''A visual inspection of some random samples of this data is discouraging, and shows differening type status (1 vs 2) for the same patient in different encounters. Based on this fact, and the low prevalence of this information to begin with, we should not include diabtype in our analysis or try to impute it within the same patient.'''
diabetes00[diabetes00['diabtype']!='Unknown'].sort_values('patient_nbr')[['patient_nbr', 'diabtype']].head(100)
diabetes00[diabetes00['diabtype']!='Unknown'].sort_values('patient_nbr')[['patient_nbr', 'diabtype']].iloc[300:400,]

#Drop diabtype from this dataframe:
diabetes02 = diabetes02.drop('diabtype', axis=1)

# '''We also need to get rid of diabetes from the diag list (we know these patients have diabetes.) Anything still numeric (or ?)
# in the diag_ features should be changed to "Nothing"'''

diabetes02['diag_1'] = diabetes02['diag_1'].replace('?', 'Nothing').astype('str')
diabetes02['diag_2'] = diabetes02['diag_2'].replace('?', 'Nothing').astype('str')
diabetes02['diag_3'] = diabetes02['diag_3'].replace('?', 'Nothing').astype('str')

d1 = list(diabetes02['diag_1'])
for i in range(len(d1)):
    try:
        pd.to_numeric(d1[i])
        d1[i] = 'Nothing'
    except:
        pass
diabetes02['diag_1'] = pd.Series(d1)

d1 = list(diabetes02['diag_2'])
for i in range(len(d1)):
    try:
        pd.to_numeric(d1[i])
        d1[i] = 'Nothing'
    except:
        pass
diabetes02['diag_2'] = pd.Series(d1)

d1 = list(diabetes02['diag_3'])
for i in range(len(d1)):
    try:
        pd.to_numeric(d1[i])
        d1[i] = 'Nothing'
    except:
        pass
diabetes02['diag_3'] = pd.Series(d1)

#Now, we have our data frame reduced to all string representations of diseases, or "Nothing." We can now combine diag 1-3:
diabetes02['diag_3'].value_counts()

#Let's combine diagnosis (diag_1, diag_2, diag_3) into dummy variables and add them. We will do this for diag and diabfeature:

#This is a function to do this
def createcombineddummies(df, c1, c2, c3=None, c4=None, c5=None, prefix=''):

    '''This would need to be modified if you have values not in every Series (we don't have that problem here)'''

    collist = [c1, c2]

    if c3 is not None:
        collist.append(c3)
    if c4 is not None:
        collist.append(c4)
    if c5 is not None:
        collist.append(c5)

    for i in range(len(collist)):

        if i == 0:
            tempDF = pd.get_dummies(df[collist[i]], prefix=prefix)

        if i > 0:
            tempDF1 = pd.get_dummies(df[collist[i]], prefix=prefix)
            tempDF = tempDF + tempDF1

    #Do we need this code? It's probably useful. Reduces everything to 1 (if a patien has 2 resporatory conditions, for example)
    tempDF = tempDF.clip(upper=1)
    tempDF = tempDF.drop(prefix + '_Nothing', axis=1)

    return tempDF

#Let's try creating this dummy DF and see how it looks:
diagDummy = createcombineddummies(diabetes02, 'diag_1', 'diag_2', 'diag_3', prefix='diag')

#This looks good. Let's combine it with diabetes02 and remove diag_1-3
diagDummy.head(10)

# Drop diag_1-3 and add diagDummy to DF
diabetes03 = diabetes02.drop(['diag_1', 'diag_2', 'diag_3'], axis=1)
diabetes03 = pd.concat([diabetes03, diagDummy], axis=1)

diabetes03.head()

#We need to modify this function (Annoying) because we have a different negative value for these columns:

#This is a function to do this
def createcombineddummiesF(df, c1, c2, c3=None, c4=None, c5=None, prefix=''):

    '''This would need to be modified if you have values not in every Series (we don't have that problem here)'''

    collist = [c1, c2]

    if c3 is not None:
        collist.append(c3)
    if c4 is not None:
        collist.append(c4)
    if c5 is not None:
        collist.append(c5)

    for i in range(len(collist)):

        if i == 0:
            tempDF = pd.get_dummies(df[collist[i]], prefix=prefix)

        if i > 0:
            tempDF1 = pd.get_dummies(df[collist[i]], prefix=prefix)
            tempDF = tempDF + tempDF1

    #Do we need this code? It's probably useful. Reduces everything to 1 (if a patien has 2 resporatory conditions, for example)
    tempDF = tempDF.clip(upper=1)
    tempDF = tempDF.drop(prefix + '_No', axis=1)

    return tempDF

#Now do a similar thing for diagfeature:
featureDummy = createcombineddummiesF(diabetes02, 'diabfeature1', 'diabfeature2', 'diabfeature3', prefix='diabfeat')

#Out of curiosity, let's see how many values are in each columns:
np.sum(featureDummy)

# '''This is a decent amount of information which could possibly help with predicting readmission rates (not sure about coma)'''

diabetes03 = diabetes03.drop(['diabfeature1', 'diabfeature2', 'diabfeature3'], axis=1)
diabetes03 = pd.concat([diabetes03, featureDummy], axis=1)

diabetes03.head()

#For now, we can drop medical_specialty and payer_code (the publication keeps specialty, but this should be quite correlated with diagnoses):
diabetes03 = diabetes03.drop('payer_code', axis=1)
diabetes03 = diabetes03.drop('medical_specialty', axis=1)

#Now, we need to adjust the values in referral. Every value above 7 (8 and above) are extremely small or missing. We should rewrite all things 8 and above as just 8:
diabetes03['admission_source_id'] = diabetes03['admission_source_id'].clip(upper=8)

#Now it is maxed out at 8; all values from 9 to 25 are converted to 8:
diabetes03['admission_source_id'].describe()

#At this point, we can fork the data into two DFs: One (AllDummy) will dummify all columns, including the medicine columns
#Another one, OrdMed, will make the medicinal columns ordinal:
#Not taking = 0, down=0.5, steady=1, up=1.5. Not sure where either of these models would work better

#A few last things to do are convert the ? in 'race' to Unknown:
diabetes03['race'] = diabetes03['race'].replace(['?'], ['unknown'])

#And for now, we should probably save the outcome (readmitted) as a un-dummified column with 3 digitized outputs:
#No=0, >30=1, <30=2 (this is completely subject to change)
diabetes03['readmitted'] = diabetes03['readmitted'].replace(['NO', '>30', '<30'], [0, 1, 2])

#One other thing: We should check value counts for all the med columns (some are VERY sparse):
for i in range(16, 39):
    colname = list(diabetes03.columns)[i]
    print(diabetes03[colname].value_counts())

#Some of these drugs can clearly be removed from this DF:
removelist = ['med_metformin-pioglitazone', 'med_metformin-rosiglitazone', 'med_glimepiride-pioglitazone',
             'med_miglitol', 'med_acetohexamide', 'med_citoglipton', 'med_examide']
diabetes03 = diabetes03.drop(removelist, axis=1)

#Function to replace a DF with dummy variables:
def ReplaceWithDummies(df, dummylist):
    df2 = df.copy()
    for var in dummylist:
        topindex = df2[var].value_counts().sort_values(ascending=False).index[0]
        dummies = pd.get_dummies(df2[var], prefix=var)
        dummies = dummies.drop(var + "_" + str(topindex), axis=1)
        df2 = pd.concat([df2, dummies], axis=1)
        df2 = df2.drop(var, axis=1)
    return df2

#Define columns to be dummified: (AllDummy vs OrdMed):
MedColumns = list(diabetes03.columns[16:32])

OrdMedDummyColumns = ['race', 'gender', 'discharge_disposition', 'max_glu_serum', 'A1Cresult', 'change', 'med_any',
                     'admission_type_id', 'admission_source_id']
AllDummyColumns = OrdMedDummyColumns
AllDummyColumns.extend(MedColumns)

#Make all dummy DF
DiabetesAllDummies = ReplaceWithDummies(diabetes03, AllDummyColumns)

#Make OrdMed df by first creating a copy of diabetes03, replacing med columns with numbers, then dummifying the others:
diabetes04 = diabetes03.copy()
for i in range(16, 32):
    colname = list(diabetes04.columns)[i]
    diabetes04[colname] = diabetes04[colname].replace(['No', 'Down', 'Steady', 'Up'], [0, 0.5, 1, 1.5])
DiabetesOrdMed = ReplaceWithDummies(diabetes04, OrdMedDummyColumns)

#Check if all values are numeric by converting to numeric:
for var in list(DiabetesAllDummies.columns):
    DiabetesAllDummies[var]  = pd.to_numeric(DiabetesAllDummies[var])
#Yes

#Check if all values are numeric by converting to numeric:
for var in list(DiabetesOrdMed.columns):
    DiabetesOrdMed[var]  = pd.to_numeric(DiabetesOrdMed[var])
#Yes

#Write these two DF's to CSV and use for further analysis:
DiabetesAllDummies.to_csv('DiabetesAllDummies.csv')
DiabetesOrdMed.to_csv('DiabetesOrdMed.csv')

DiabetesOrdMed.head(10)
