# -*- coding: utf-8 -*-
"""
Created on Sun Nov  3 20:14:19 2019

@author: alinathani
CLASSIFICATION MODELS
DATASET : Server App relationship List
Notes on Data description: (Interview with Project manager)
Recovery time objective for servers to come back online
Recover Point objective till what time can you backup or retrieve data

RTO - inhouse vs SLA for 3rd party vendors
RTO - dependendent on risk appetite


0 hrs = has to be available continuously regardless (critical on service impact)
< 4hrs = not as much service impact
0 & < 4hrs = in between - 0 - 4 hrs (depending on other variables) dependancy on other factors

blank = not able to locate them




"""

#================================LOGISTIC REGRESSION=============================#
import os
import pandas as pd
os.chdir(r'C:\Users\alina_000\Desktop\ML\Project')

#IMPORT LIBRARIES
import pandas as pd
import numpy as np
from scipy import stats
from datetime import datetime
from sklearn import preprocessing
import seaborn as sns
import matplotlib.cm as cm
from sklearn.model_selection import train_test_split
from sklearn.model_selection import KFold
import statsmodels.api as sm
from sklearn.metrics import mean_squared_error, r2_score
import matplotlib.pyplot as plt
%matplotlib auto

data2 = pd.read_excel('Server App relationship List.xlsx')
data2 = data2.iloc[:,:6]
#CHECK INFO AND FOR NULL VALUES
data2.info()
data2.isnull().sum()
data2.describe().T
data2.columns
data2.shape
#REMOVE ROWS WITH MISSING VALUES
dataset2=data2.dropna(axis='rows',how='any')
dataset2.info()
dataset2.isnull().sum()
dataset2.describe().T
dataset2.columns
dataset2.shape
#as some of the values in target column differ in capitalization and spacing, but 
#belong to the same category, some pre-processing is needed


# Establish in- and dependent variables

y=dataset2['Business MAD/RTO']
y = [str(i).lower() for i in y] 
y=[str(i).replace(" ","") for i in y]
#dummy variable encoding for nominal variables

X = pd.get_dummies(dataset2,columns=['Application','Environment','Location'],drop_first=True, prefix=['App','Env','Loc'])
X=X.drop(['Server Name','Business MAD/RTO','Business RPO'],axis=1)
X.info()

from sklearn.linear_model import LogisticRegression
from sklearn.preprocessing import StandardScaler
from sklearn.metrics import accuracy_score, confusion_matrix, precision_score, recall_score, classification_report
from sklearn.model_selection import cross_val_score

#Scaling
from sklearn.preprocessing import StandardScaler

sc = StandardScaler()
x_fit = sc.fit_transform(X)

x_scaled = pd.DataFrame(x_fit, index=X.index, columns=X.columns)
# Create train and test sets 70:30
x_train, x_test, y_train, y_test = train_test_split(x_scaled, y, test_size = 0.3, random_state = 0)
#import classifier
model = LogisticRegression()
#train model
model.fit(x_train, y_train)
#predict on test set
y_pred = model.predict(x_test)

accuracy_score (y_test, y_pred)
conm = confusion_matrix (y_test, y_pred)
print(conm)
print(classification_report(y_test,y_pred))
# using micro, macro average for multiclass
sensitivity1 = recall_score(y_test, y_pred, average='micro')
sensitivity2 = recall_score(y_test, y_pred, average='macro')
#sensitivity = TP/(TP+FN)
precision1 = precision_score(y_test, y_pred, average='micro')
precision2 = precision_score(y_test, y_pred, average='macro')

print(sensitivity1)
print(sensitivity2)
print(precision1)
print(precision2)
#Probability check
probabilities = model.predict_proba(x_test)
y_pred_prob = model.predict_proba(x_test)[:,1]

#K-FOLD

from sklearn.model_selection import cross_val_score
clf = LogisticRegression()
cross_val_score(clf,x_scaled,y,cv=10).mean()
#K-fold score of 0.850897 shows that the model's accuracy is consistent throughout the Dataset



#=======================KNN====================================================#

from sklearn.neighbors import KNeighborsClassifier
modelKNN = KNeighborsClassifier()
grid_paramsKNN = {'n_neighbors': [1,2,3,4,5,6,7,8,9,10,11]}

from sklearn.model_selection import GridSearchCV
clfKNN = GridSearchCV(modelKNN, grid_paramsKNN, scoring='accuracy', cv=4)

clfKNN.fit(X,y)
clfKNN.best_params_ 
clfKNN.best_estimator_
clfKNN.best_score_ 
#n_neighbors = 1
#import model KNNC
from sklearn.neighbors import KNeighborsClassifier
modelKNC = KNeighborsClassifier(n_neighbors=1,metric = 'minkowski', p = 2)

#training
modelKNC.fit(x_train, y_train)

#prediction
y_pred = modelKNC.predict(x_test)

from sklearn.metrics import accuracy_score, confusion_matrix, precision_score, recall_score, classification_report

#accuracy KNN
accuracy_score (y_test, y_pred)

confusion_matrix (y_test, y_pred)

#pip install -q scikit-plot 
import scikitplot as skplt
skplt.metrics.plot_confusion_matrix(y_test,y_pred)

from sklearn.ensemble import AdaBoostClassifier
#====================Adaboost==================================================#
#GridSearchCV for AdaBoost

modelAdaBC = AdaBoostClassifier(DecisionTreeClassifier(max_depth=3))
grid_params2={
            'n_estimators': range(25,50,10)}
adaboostGSCV = GridSearchCV(modelAdaBC, grid_params2, scoring='accuracy', cv=4)

adaboostGSCV.fit(X,y)

adaboostGSCV.best_params_ 
adaboostGSCV.best_estimator_
adaboostGSCV.best_score_
#Best Parameters{'n_estimators': 35}
#AdaBoostClassifier

adaboostcl = AdaBoostClassifier(DecisionTreeClassifier(max_depth=2),n_estimators=35, random_state=0 )

adaboostcl.fit(x_train, y_train)

#accuracy
adaboostcl.score(x_test, y_test)

from sklearn.tree import DecisionTreeClassifier
from sklearn.ensemble import RandomForestClassifier
#======================Random Forest===========================================#
#GridSearchCV for Randomforest
from sklearn.model_selection import GridSearchCV
modelRFC = RandomForestClassifier(random_state=0)

grid_params3={
            'max_depth':[1,2,3,4,5],
            'n_estimators': [40,50,60,70,80,90,100]}

randomf = GridSearchCV(modelRFC, grid_params3, scoring='accuracy', cv=4)#scoring for classifier is accuracy and r-square for regression
randomf.fit(X,y)
randomf.best_params_
randomf.best_estimator_
randomf.best_score_ 
#{'max_depth': 5, 'n_estimators': 50}

#RandomForestClassifier
randomcl = RandomForestClassifier(max_depth=5, n_estimators=50, random_state=0)
randomcl.fit(x_train, y_train)

#accuracy
randomcl.score(x_test, y_test)

#======================== SVM Model============================================#
# GridSearchCV SVC
from sklearn.svm import SVC
svc_model = SVC() #default = rbf
grid_params={
            'kernel': ['rbf', 'poly', 'linear']}
svcgcv = GridSearchCV(svc_model, grid_params, scoring='accuracy', cv=4)

svcgcv.fit(X,y)

svcgcv.best_params_ 
svcgcv.best_estimator_
svcgcv.best_score_

#-------
svc_model = SVC(kernal='')
svc_model.fit(x_train,y_train)

svc_model.score(x_test, y_test)

