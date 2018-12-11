import pandas as pd
import numpy as np

#Import the train dataset (here, we have no train/test split, it is all train)
DiabetesTakingMed = pd.read_csv('DiabetesTakingMedF.csv', index_col=0)

DiabetesTakingMed = DiabetesTakingMed.drop('IsTrain', axis=1)
DiabetesNoMiddle = DiabetesTakingMed[DiabetesTakingMed['readmitted']!=1]
trainX01 = DiabetesNoMiddle.drop('readmitted', axis=1)
trainY01 = DiabetesNoMiddle['readmitted'].replace([2], [1])


#Remove train data where patients came back after 30 days, who look very similar to those returning <30 days:
from sklearn.linear_model import LinearRegression as lm
lm = lm()
lm.fit(trainX01, trainY01)

DiabetesMiddle = DiabetesTakingMed[DiabetesTakingMed['readmitted']==1]
MiddleX = DiabetesMiddle.drop('readmitted', axis=1)
MiddleY = DiabetesMiddle['readmitted']

predictarray = lm.predict(MiddleX)

MiddleDF75 = DiabetesMiddle.loc[predictarray<0.75]

FinalTrain = pd.concat([DiabetesNoMiddle, MiddleDF75], axis=0)

#Get the logistic regression fit object, after removing specific columns:

TrainLR = FinalTrain.drop(['diabfeat_neurologic', 'race_AfricanAmerican', 'A1Cresult_>7', 'primarydiag_injury', 'number_diagnoses', 
    'med_glimepiride', 'med_insulin', 'diag_infection', 'medical_specialty_Orthopedics', 'med_nateglinide', 'discharge_disposition_leftAMA', 
    'admission_source_id_3', 'change_Ch', 'diag_circulatory', 'medical_specialty_Gastroenterology', 'medical_specialty_Surgery',
    'primarydiag_infection', 'primarydiag_mentaldis'], axis=1)
TrainLRX = TrainLR.drop('readmitted', axis=1)
TrainLRY = TrainLR['readmitted']

from sklearn.linear_model import LogisticRegression as lgr

lgr = lgr()
lgr.set_params(C=0.1, class_weight={0:.2, 1:.8})

lgr.fit(TrainLRX, TrainLRY)

#Get random forest fit object:

from sklearn.ensemble import RandomForestClassifier as rfc

rfc = rfc()
rfc.set_params(n_estimators=1000, min_samples_split=5, min_samples_leaf=1, max_features='sqrt', 
               max_depth=60, random_state=42, class_weight={0:.2, 1:.8})

FinalTrainX = FinalTrain.drop('readmitted', axis=1)
FinalTrainY = FinalTrain['readmitted']

rfc.fit(FinalTrainX, FinalTrainY)

from xgboost.sklearn import XGBClassifier as xgb

xgb = xgb()
xgb.set_params(n_estimators=500, min_child_weight=10, max_depth=5, gamma=5, colsample_bytree=0.6, max_delta_step=5,
              random_state=42, scale_pos_weight=1)

xgb.fit(FinalTrainX, FinalTrainY)


#Now, import new test cleaned test set and run it through our model:
TestDF = pd.read.csv(filename)
TestDF = TestDF.drop('IsTrain', axis=1)

TestDFLR = TestDF.drop((['diabfeat_neurologic', 'race_AfricanAmerican', 'A1Cresult_>7', 'primarydiag_injury', 'number_diagnoses', 
    'med_glimepiride', 'med_insulin', 'diag_infection', 'medical_specialty_Orthopedics', 'med_nateglinide', 'discharge_disposition_leftAMA', 
    'admission_source_id_3', 'change_Ch', 'diag_circulatory', 'medical_specialty_Gastroenterology', 'medical_specialty_Surgery',
    'primarydiag_infection', 'primarydiag_mentaldis'], axis=1))

predictprobsLR = lgr.predict_proba(TestDFLR)

predictprobsRF = rfc.predict_proba(TestDF)

predictprobsXG = xgb.predict_proba(TestDF)

predictprobs = 56*predictprobsXG/100 + 23*predictprobsRF/100 + 21*predictprobsLR/100
predictYN = np.zeros(len(predictprobs))
predictYN[predictprobs>0.5] = 1

TestDFPredict = TestDF.copy()
TestDFPredict['Prob'] = pd.Series(predictprobs)
TestDFPredict['Predict'] = pd.Series(predictYN)

TestDFPredict.to_csv('TestDFPredict.csv')




