#!/usr/bin/env python
# coding: utf-8

# #    # This is a Python Project on an Amazon e-commerce Customer Reviews Data Set with Fashion Products

# # DATA GATHERING AND CLEANSING

# In[ ]:


# Connect to dataset


# In[112]:


import os
os.chdir(r"C:\Users\alina\Documents\dsa python prject\Ali\Data")
os.getcwd()

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
%matplotlib auto
#get_ipython().run_line_magic('matplotlib', 'inline')

from scipy import stats
from datetime import datetime
from sklearn import preprocessing
import seaborn as sns

import matplotlib.cm as cm

from sklearn.model_selection import train_test_split
from sklearn.model_selection import KFold
from sklearn import preprocessing
from sklearn.linear_model import LinearRegression
import statsmodels.api as sm
from sklearn.metrics import mean_squared_error, r2_score
from sklearn.preprocessing import MinMaxScaler


# In[4]:


#pip install pandas-profiling


# In[194]:


import pandas_profiling


# In[195]:


#Read files:
train = pd.read_csv("amazoncoecommercesam-fashion-products-on-amazon-com-QueryResult.csv")
test = pd.read_csv("amazon_co-ecommerce_sample.csv")


# In[196]:


train['source']='train'
train.head()
test['source']='test'
data=pd.concat([train,test],ignore_index=True,sort=True)
print(train.shape, test.shape, data.shape)


# In[197]:f

data.head(10)


# In[77]:


data.tail(10)


# In[50]:


pandas_profiling.ProfileReport(data)


# In[198]:


#find missing values
data.isnull().sum()


# In[199]:


# Looking for missing values
total = data.isnull().sum().sort_values(ascending=False)
percent = (data.isnull().sum()/data.isnull().count()).sort_values(ascending=False)
missing_data = pd.concat([total, percent], axis=1, keys=['Total', 'Percent'])
missing_data.to_excel(r'C:\Users\alina\Documents\dsa python prject\Ali\missing_data.xlsx')
print(missing_data)


# #the below code outputs the records with null values in the average_review_rating column and outputs these records

# In[10]:


bool_series = pd.isnull(data["average_review_rating"])  
    
# filtering data  
# displaying data only with average_review_rating = NaN  
data[bool_series]


# #below code saves in a variable, the records with null values in the average_review_rating column as boolean and then counts them in the following code and finally saves the notnull records to bool_series2 and create a new dataframe data2 without these records

# In[11]:


bool_series.value_counts()


# In[12]:


bool_series2 = pd.notnull(data["average_review_rating"])  


# In[13]:


data2=data[bool_series2]


# In[14]:


data2["average_review_rating"].isnull().sum()


# In[15]:


#check for missing values in the amazon_category_and_sub_category column in the new dataframe data2
bool_series3 = pd.isnull(data2["amazon_category_and_sub_category"])  
    
# filtering data  
# displaying data only with amazon_category_and_sub_category = NaN  
data2[bool_series3].head()


# In[16]:


bool_series3.value_counts()


# #above code separates records with null values inside the amazon_category_and_sub_category column and outputs the first five records, the second code below, outputs the product_name for the above first_five records and shows that a product name exists for these records, therefore it is better to keep these records for now as though no rating was given 

# In[17]:


data2[bool_series3]['product_name'].head()


# In[18]:


data2.nunique()


# In[19]:


data2.average_review_rating.value_counts()


# In[20]:


data2[data2['average_review_rating'] == '5.0 out of 5 stars']['amazon_category_and_sub_category'].value_counts()


# In[21]:


data2[data2['average_review_rating'] == '5.0 out of 5 stars']['amazon_category_and_sub_category'].value_counts().head(1)



# In[53]:


data2.info()


# In[22]:


data2.astype('object').describe().transpose()


# In[51]:


data2.astype('object').describe().transpose().to_excel(r'C:\Users\alina\Documents\dsa python prject\Ali\Data2ObjectDescriptions.xlsx')


# In[22]:


#Filter categorical variables
categorical_columns = [x for x in data.dtypes.index if data.dtypes[x]=='object']
#Exclude unique_ID and source:
categorical_columns = [x for x in categorical_columns
                      if x not in ['uniq_id','source']]
#print frequency of categories
for col in categorical_columns:
    print ('\n\Frequency of Categories for variable %s'%col)
    print (data[col].value_counts())


# In[23]:


data2.dtypes.index


# In[178]:


# DEAL WITH AVERAGE_REVIEW_RATING


# In[24]:


#remove the text in rating and convert to Numeric
data2['average_review_rating'] = pd.to_numeric(data2['average_review_rating'].str.replace(' out of 5 stars', ''), errors='coerce')


# In[25]:


#review the unique values for average_review_rating
data2.average_review_rating.value_counts()


# In[164]:


#DEALING WITH MISSING VALUES FOR MANUFACTURER


# In[33]:


#save and read records with missing values for manufacturer
bool_series4 = pd.isnull(data2["manufacturer"])  

data2[bool_series4]['product_name']


# In[37]:


#see all records with missing values for manufacturer
data2[bool_series4]


# In[34]:


#check the categories for missing manufacturerr

data2[bool_series4]['amazon_category_and_sub_category']


# In[48]:


#replace NaN values in manufacturer with Unknown
data2["manufacturer"].fillna('Unknown', inplace = True)


# In[49]:


#check for missing values again
total2 = data2.isnull().sum().sort_values(ascending=False)
percent2 = (data2.isnull().sum()/data2.isnull().count()).sort_values(ascending=False)
missing_data2 = pd.concat([total2, percent2], axis=1, keys=['Total', 'Percent'])
print(missing_data2)


# In[165]:


#CHECKING FOR NON-NUMERIC COLUMNS THAT NEED TO BE CONVERTED TO NUMERIC


# In[78]:


data2.info()


# In[96]:


data2['number_of_answered_questions'].unique()


# In[98]:


data2['number_of_answered_questions']=pd.to_numeric(data2['number_of_answered_questions'])


# In[106]:


data2['number_of_reviews'] = pd.to_numeric(data2['number_of_reviews'].str.replace(',', ''), errors='coerce')


# In[190]:



data2['number_available_in_stock'] = data2['number_available_in_stock'].str.extract('(\d+)')
data2['number_available_in_stock']= pd.to_numeric(data2['number_available_in_stock'])

# In[192]:


data2['price'] = pd.to_numeric(data2['price'].str.replace('£', ''), errors='coerce')
data2['price']= pd.to_numeric(data2['price'])

# In[188]:


data2.info()


# In[180]:


data2.head()

#EXTRACT CATEGORIES
data2['amazon_category'] = data2['amazon_category_and_sub_category'].str.extract('(\w+)')
data2['amazon_category'].head()
data2['amazon_category'].unique()
data2['amazon_category_and_sub_category'].head(1)
# In[108]:


datasubset = pd.notnull(data2)


# In[109]:


data3=data2

data3.isnull().sum()
# In[113]:


#heat map 1
corr=data3.corr()
plt.figure(figsize=(14,10))
sns.heatmap(corr,annot=True,cmap=plt.cm.Reds)


# In[115]:


data3.info()



# In[146]:


topmanufact=pd.DataFrame(data3['manufacturer'].value_counts().head(265))


# In[143]:


topmanufact


# In[149]:

#ENCODING
data3.isnull().sum()
data4 = data3.dropna()
data4.info()
data4.isnull().sum()


#data4=data3[data3['manufacturer'].isin(['LEGO','Disney','Oxford Diecast','Playmobil','The Puppet Company','Mattel','Star Wars','Scalextric','Hornby','Hasbro'])]

data4.max()
data4.min()
#PLOTTING

#pairplot
sns.pairplot(data4,kind='reg')
#boxplots univariate
#average_review_rating
sns.boxplot(x='average_review_rating', data=data4)


#number_available_in_stock
sns.boxplot(x='number_available_in_stock', data=data4)


#number_of_answered_questions
sns.boxplot(x='number_of_answered_questions', data=data4)


#number_of_reviews
sns.boxplot(x='number_of_reviews', data=data4)


#price
sns.boxplot(x='price', data=data4)


sns.boxplot(x='manufacturer', y ='average_review_rating', data=data4, order=data4['manufacturer'].value_counts().index)
sns.boxplot(x='number_available_in_stock', y ='average_review_rating', data=data4, order=data4['number_available_in_stock'].value_counts().index)



sns.set(style='darkgrid')
BoW=sns.boxplot(x='manufacturer', y ='average_review_rating', data=data4, order=data4['manufacturer'].value_counts().index)
SoW=sns.stripplot(x='manufacturer', y='average_review_rating', data=data4, color="orange", jitter=0.2, size=0.5,  order=data4['manufacturer'].value_counts().index)
plt.title("average_review_rating per manufacturer")



sns.boxplot(x='manufacturer', y ='average_review_rating', data=data4, order=data4['manufacturer'].value_counts().index)
plt.title("Taverage_review_rating per manufacturer")
plt.xlabel("")
plt.ylabel("")
sns.boxplot(x='manufacturer', y ='average_review_rating', data=data4, order=data4['manufacturer'].value_counts().index)


sns.boxplot(x='manufacturer', y ='average_review_rating', data=data4, order=data4['manufacturer'].value_counts().index)
plt.title("Taverage_review_rating per manufacturer")
plt.xlabel("")
plt.ylabel("")



# In[150]:


data4.head()


# In[159]:


data4.shape


# In[160]:


data4.info()
data4.isnull().sum()

data4.number_of_reviews.fillna(data4.number_of_reviews.mean(), inplace=True)
data4.number_available_in_stock.fillna(data4.number_available_in_stock.mean(), inplace=True)
data4.number_of_answered_questions.fillna(data4.number_of_answered_questions.mean(), inplace=True)
data4.price.fillna(data4.price.mean(), inplace=True)


data4.amazon_category[data4.amazon_category.isna()==True]='Characters'
data4['amazon_category'].isna().sum()

data4.shape
data4.isnull().sum()

# In[ ]:

#PREPARE FOR RUNNING THE MODEL - SEPARATE X AND Y AND ENCODE DUMMIES
y=data4.average_review_rating
x=data4.drop(['product_name','amazon_category_and_sub_category','customer_reviews','average_review_rating','customer_questions_and_answers','items_customers_buy_after_viewing_this_item','sellers','customers_who_bought_this_item_also_bought','product_description','description','product_information','source','uniq_id'],axis=1)
x.info()

x.isnull().sum()
x.shape
y.shape

xencoded= pd.get_dummies(x, columns=['manufacturer', 'amazon_category'],
                    drop_first=True, prefix=['manufacturer','amazon_category'])

xencoded.isnull().sum()
# In[114]:




#create model
import statsmodels.api as sm
from sklearn.linear_model import LinearRegression
from sklearn.metrics import mean_squared_error, r2_score
from sklearn.preprocessing import MinMaxScaler
from sklearn.model_selection import train_test_split
from sklearn.neighbors import KNeighborsRegressor
from sklearn.model_selection import GridSearchCV
from sklearn.linear_model import SGDRegressor
from sklearn.ensemble import RandomForestRegressor
from sklearn.ensemble import AdaBoostRegressor
from sklearn.tree import DecisionTreeRegressor
from sklearn.model_selection import cross_val_score
from sklearn.svm import SVR


#Scaling
from sklearn.preprocessing import MinMaxScaler
mm = MinMaxScaler()

x_scaled=pd.DataFrame(mm.fit_transform(xencoded), columns =xencoded.columns)


# Create train and test sets
from sklearn.model_selection import train_test_split
X_train, X_test, y_train, y_test = train_test_split(xencoded,y,test_size=0.3,random_state=0)

# Backward Feature Elimination
def remove_maxpvalcol(drop_col, X_train, X_test):    
    X_train.drop([drop_col], axis = 1, inplace = True)
    X_test.drop([drop_col], axis = 1, inplace = True)
    
def model_fit(X_train, y_train):
    import statsmodels.api as sm
    X1 = sm.add_constant(X_train)
    return sm.OLS(y_train, X1).fit()

while True: 
    lr = model_fit(X_train, y_train)
    lr_pval_max = lr.pvalues.max()
    if lr_pval_max > 0.01:
        drop_col = lr.pvalues[lr.pvalues == lr_pval_max].index[0]
        print('Dropping column : {}'.format(drop_col)) 
        remove_maxpvalcol(drop_col, X_train, X_test);
    else:
        break;

print(lr.summary())




#Linear regression model using OLS
import statsmodels.api as sm
X1 = sm.add_constant(X_train)

ols = sm.OLS(y_train,X1)
lr = ols.fit()

print(lr.summary())


# Train the model

model = LinearRegression()
model.fit(X_train,y_train)

# Test the model

y_pred = model.predict(X_test)


print(mean_squared_error(y_test,y_pred))
print(r2_score(y_test,y_pred))
print(r2_score(y_train,model.predict(X_train)))


model.intercept_
model.coef_
mean_squared_error(y_test,y_pred)
r2_score(y_test,y_pred)
r2_score(y_train,model.predict(X_train))




#DECISION TREE


adaboostmodel = AdaBoostRegressor(DecisionTreeRegressor(max_depth=3),learning_rate = 4, n_estimators = 450)
adaboostmodel.fit(xencoded, y)
adaboostmodel.score(x_test, y_test)

#PLOT ENCODED VALUES
sns.pairplot(xencoded)

# In[ ]:

model4=RandomForestRegressor()
grid_params_RF={
           'n_estimators':range(50,90,10),
           'max_depth':[15,16,17,18,19,20,21]
           }
clf4=GridSearchCV(model4,grid_params_RF,cv=4,scoring='r2')
clf4.fit(x_scaled, y)
clf4.best_params_ 
clf4.best_score_
# Best Params 'max_depth':19 , 'n_estimators': 60
randformodel = RandomForestRegressor( max_depth= 19, n_estimators = 60)
randformodel.fit(x_scaled,y)
randformodel.score(X_test,y_test)





