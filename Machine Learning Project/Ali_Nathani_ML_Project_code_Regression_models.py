# -*- coding: utf-8 -*-
"""
Created on Sat Nov  2 21:46:04 2019

@author: alinathani
REGRESSION MODELS
DATASET : CONCRETE
"""
#================================LINEAR REGRESSION=============================#

import os
import pandas as pd
os.chdir(r'C:\Users\alina_000\Desktop\ML\Project')

#IMPORT LIBRARIES
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
import matplotlib.cm as cm
import statsmodels.api as sm
from scipy import stats
from datetime import datetime
import statsmodels.formula.api as smf
from sklearn import preprocessing
from sklearn.model_selection import KFold
import matplotlib.pyplot as plt
%matplotlib auto
import matplotlib.cm as cm
from sklearn import metrics


#Read the Dataset
dataset=pd.read_csv('concrete.csv')
dataset.count()
dataset.isnull().sum()
#dataset information
df=dataset.describe().T
df.to_html(r'datadescription.html')

#check correlation prior to processing
cor=dataset.corr()
#heatmap
sns.heatmap(cor,annot=True,cmap=plt.cm.Reds)

X=dataset.drop(['csMPa'], axis = 1)
y=dataset.csMPa

#Scaling
from sklearn.preprocessing import MinMaxScaler
mm = MinMaxScaler()

x_scaled=pd.DataFrame(mm.fit_transform(X), columns =X.columns)

#OLS backward feature elimination in order to remove variables with p value
X1=sm.add_constant(x_scaled) 
ols=sm.OLS(y,X1)
lr=ols.fit()
p=lr.pvalues
pvalue=max(lr.pvalues[1:len(lr.pvalues)])
print(lr.summary())

while (pvalue>=0.05):
    loc=0
    for i in lr.pvalues:
        if (i==pvalue):
            feature=lr.pvalues.index[loc]
            print(feature)
            break
        loc+=1
    x_scaled=x_scaled.drop(feature,axis=1)
    X1=sm.add_constant(x_scaled) 
    ols=sm.OLS(y,X1)
    lr=ols.fit()
    pvalue=max(lr.pvalues[1:len(lr.pvalues)])
    print(lr.summary())


# Create train and test sets
from sklearn.model_selection import train_test_split
X_train, X_test, y_train, y_test = train_test_split(X,y,test_size=0.3,random_state=0)

#Train for Linear Regression
from sklearn.linear_model import LinearRegression
model=LinearRegression()
model.fit(X_train, y_train)

# Test the model
y_pred = model.predict(X_test)

model.coef_
model.intercept_

#calcutating the R Squared value
from sklearn.metrics import mean_squared_error, r2_score
 r2_score(y_test, y_pred)

print(mean_squared_error(y_test, y_pred))
print(r2_score(y_test, y_pred))
print(r2_score(y_train,model.predict(X_train)))


#K-fold cross-validation (K=3)
from sklearn.model_selection import cross_val_score
#R2 score
print (cross_val_score(model,X,y,cv=3))
#mean R-square: 
print (cross_val_score(model,X,y,cv=3).mean())

#RMSE    
print (np.sqrt(-cross_val_score(model,X,y,cv=3,scoring='neg_mean_squared_error')).mean())


#===============================KNN============================================#

#reimport X & y from original dataset as 2 columns lost in the linear regression model after scaling was done
#create new data values for X & y for same dataset
X2=dataset.drop(['csMPa'], axis = 1)
y2=dataset.csMPa

mm = MinMaxScaler()

x_scaled2=pd.DataFrame(mm.fit_transform(X2), columns =X2.columns)

#splitting dataset into training and test-set
from sklearn.model_selection import train_test_split
x_train2, x_test2, y_train2, y_test2 = train_test_split(x_scaled2,y2,random_state=0)


#KNN GridsearchCV
from sklearn.neighbors import KNeighborsRegressor
from sklearn.model_selection import GridSearchCV
modelKNN = KNeighborsRegressor()
grid_paramsKNN = {'n_neighbors': [1,2,3,4,5,6,7,8,9,10,11]}

clf = GridSearchCV(modelKN, grid_paramsKN, scoring='r2', cv=4)

clf.fit(x_scaled2,y2)
clf.best_params_ 
clf.best_estimator_
clf.best_score_ 
#Best N-Neighbor result was 8
#Import the model
model2 = KNeighborsRegressor(n_neighbors = 8)
#Train the model
model2.fit(x_train2,y_train2)
#Predict the model
y_pred2 = model.predict(x_test2)
#check the score
model2.score(x_test2,y_test2)

#=====================Adaboost=================================================#
from sklearn.ensemble import RandomForestRegressor
from sklearn.ensemble import AdaBoostRegressor
from sklearn.tree import DecisionTreeRegressor

model3=AdaBoostRegressor(DecisionTreeRegressor(max_depth=3))
grid_params_adaboost={
           'n_estimators':range(100,500,50),
           'learning_rate':[0.5,1,2,4,6]
           }
clf3=GridSearchCV(model3,grid_params_adaboost,cv=4,scoring='r2')
clf3.fit(x_scaled2,y2)
clf3.best_params_ 
clf3.best_score_

# Best parameters found learning rate: 4 & n_estimators: 450
adaboostmodel = AdaBoostRegressor(DecisionTreeRegressor(max_depth=3),learning_rate = 4, n_estimators = 450)
adaboostmodel.fit(x_scaled2, y2)
adaboostmodel.score(x_test2, y_test2)

#=====================Random Forest============================================#

model4=RandomForestRegressor()
grid_params_RF={
           'n_estimators':range(50,90,10),
           'max_depth':[15,16,17,18,19,20,21]
           }
clf4=GridSearchCV(model4,grid_params_RF,cv=4,scoring='r2')
clf4.fit(x_scaled2, y2)
clf4.best_params_ 
clf4.best_score_
# Best Params 'max_depth':16 , 'n_estimators': 80
randformodel = RandomForestRegressor( max_depth= 16, n_estimators = 80)
randformodel.fit(x_scaled2,y2)
randformodel.score(x_test2,y_test2)

#=====================SVM======================================================#

from sklearn.svm import SVR
from sklearn.model_selection import GridSearchCV

grid_params_SVR = {'kernel':['rbf', 'poly','linear']}

model5 = GridSearchCV(SVR(gamma=0.2),grid_params_SVR, cv=4)
model5.fit(x_scaled2,y2)
model5.best_params_ 
#'kernel': 'linear'
clf5 = SVR(kernel='linear')
clf5.fit(x_train2,y_train2)
clf5.score(x_test2,y_test2)
