# -*- coding: utf-8 -*-



import os
os.chdir(r'C:\Users\Owner\Desktop\Machine learning\mini')
os.getcwd()



import pandas as pd
import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt
import statsmodels.api as sm
from sklearn.linear_model import LinearRegression
from sklearn.metrics import mean_squared_error, r2_score
from sklearn.preprocessing import MinMaxScaler
from sklearn.model_selection import train_test_split
%matplotlib auto


data = pd.read_csv('concrete.csv')


data.info()
data.isnull().sum()
data.describe().T
data.columns
data.head()
data.shape

#Preprocessing
cor=data.corr()
#heatmap
sns.heatmap(cor,annot=True,cmap=plt.cm.Reds)
#pairplot with regression line
sns.pairplot(data, kind='reg')

# Establish in- and dependent variables
x = data.drop(['csMPa'], axis = 1)
y = data.csMPa

from sklearn.preprocessing import MinMaxScaler
mm = MinMaxScaler()

x_scaled=pd.DataFrame(mm.fit_transform(x), columns =x.columns)

sns.pairplot(x_scaled, kind = 'reg')

#OLS backward feature analysis
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

#Splitting the dataset into train and test: 70:3-
x_train, x_test, y_train, y_test = train_test_split(x_scaled, y, test_size = 0.3, random_state = 0)



#Fitting  multiple Linear Regression
from sklearn.linear_model import LinearRegression
regressor=LinearRegression()
regressor.fit(x_train, y_train)

# Test the model
y_pred = regressor.predict(x_test)
regressor.coef_
regressor.intercept_

#calcutating the R Squared value
from sklearn.metrics import r2_score
 r2_score(y_test, y_pred)


############################################################################
####                       KNN                                          ####
############################################################################

# Establish in- and dependent variables
xnew = data.drop(['csMPa'], axis = 1)
ynew = data.csMPa


mm = MinMaxScaler()

x_scalednew=pd.DataFrame(mm.fit_transform(xnew), columns =xnew.columns)

#splitting dataset into training and test-set
from sklearn.model_selection import train_test_split
x_trainn, x_testn, y_trainn, y_testn = train_test_split(x_scalednew,ynew,random_state=0)


#KNN
'''
from sklearn.model_selection import cross_val_score
score=[]
for k in range(1,20):
    model=KNeighborsRegressor(n_neighbors=k,p=2,metric='minkowski')
    model.fit(xnew,ynew)
    score.append(cross_val_score(model,xnew,ynew,cv=4).mean())
print('max r2_score:',max(score))
print('K with max r2_score is:',score.index(max(score))+1)
plt.bar(x=range(1,20),height=score)
plt.show()
'''
#KNN GridsearchCV
from sklearn.neighbors import KNeighborsRegressor
from sklearn.model_selection import GridSearchCV
modelKN = KNeighborsRegressor()
grid_paramsKN = {'n_neighbors': [1,2,3,4,5,6,7,8,9,10,11]}

clfKN = GridSearchCV(modelKN, grid_paramsKN, scoring='r2', cv=4)

clfKN.fit(x_scalednew,ynew)
clfKN.best_params_ #n_neighbors = 8
clfKN.best_estimator_
clfKN.best_score_ #CV means

#import model
model = KNeighborsRegressor(n_neighbors = 8)
#training
model.fit(x_trainn,y_trainn)
#predictions
y_pred = model.predict(x_testn)

model.score(x_testn,y_testn)



#####SGD Regressor
#GridSearchCV for SGDRegressor
from sklearn.linear_model import SGDRegressor
modelSGDR = SGDRegressor(loss='squared_loss')
grid_params={'eta0':[0.001,0.01,0.1],
            'learning_rate':['constant','optimal','invscaling'],
                             'alpha':[0.001,0.01,0.1]}

clf = GridSearchCV(modelSGDR, grid_params, scoring='r2', cv=4)#scoring for classifier is accuracy and r-square for regression
clf.fit(x_scalednew,ynew)
clf.best_params_ #{'alpha': 0.001, 'eta0': 0.01, 'learning_rate': 'constant'}
clf.best_estimator_
clf.best_score_ #CV means 

sgred = SGDRegressor(loss='squared_loss', learning_rate = 'constant', eta0 = 0.1, alpha=0.0001) #eta0 is the step size
sgred.fit(x_scalednew,ynew)

sgred.score(x_testn,y_testn)
##################--------------------------------------------------#
#Adaboost
from sklearn.ensemble import RandomForestRegressor
from sklearn.ensemble import AdaBoostRegressor
from sklearn.tree import DecisionTreeRegressor

model=AdaBoostRegressor(DecisionTreeRegressor(max_depth=3))
para_dict={
           'n_estimators':[300,350,400,450],
           'learning_rate':[0.5,1,2,4,6]
           }
clf=GridSearchCV(model,para_dict,cv=4,scoring='r2')
clf.fit(x_scalednew,ynew)
clf.best_params_ #{'learning_rate': 4, 'n_estimators': 350}
clf.best_score_


adamodel = AdaBoostRegressor(DecisionTreeRegressor(max_depth=3),learning_rate = 4, n_estimators = 350)
adamodel.fit(x_scalednew, ynew)
adamodel.score(x_testn, y_testn)

#Random Forest
model=RandomForestRegressor()
para_dict={
           'n_estimators':range(150,250,10),
           'max_depth':[15,16,17,18,19,20,21]
           }
clf=GridSearchCV(model,para_dict,cv=4,scoring='r2')
clf.fit(x_scalednew, ynew)
clf.best_params_ # {'max_depth': 17, 'n_estimators': 230}
clf.best_score_

rndmodel = RandomForestRegressor( max_depth= 17, n_estimators = 230)
rndmodel.fit(x_scalednew,ynew)
rndmodel.score(x_testn,y_testn)

#############################################################
#####                     SVM                            ####
#############################################################

from sklearn.svm import SVR
from sklearn.model_selection import GridSearchCV

param_grid = {'kernel':['rbf', 'poly','linear']}

model = GridSearchCV(SVR(gamma=0.2),param_grid, cv=4)
model.fit(x_scalednew,ynew)
model.best_params_ #{'kernel': 'linear'}

clf = SVR(kernel='linear')
clf.fit(x_trainn,y_trainn)
clf.score(x_testn,y_testn)
