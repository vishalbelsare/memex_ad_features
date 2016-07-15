#!/usr/bin/python
# -*- coding: utf-8 -*-
import pandas
import numpy as np
import datetime
import ipdb
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.feature_selection import SelectFromModel
from sklearn.pipeline import Pipeline
from sklearn.cross_validation import cross_val_score
from sklearn.linear_model import LinearRegression

from sklearn.ensemble import RandomForestRegressor 
data = pandas.read_csv('data/temp/ad_ids_with_price.csv')
prices = pandas.read_csv('ad_price_ad_level.csv')
#data1 = data.loc[np.random.choice(data.index, 100)]
#data2 = data.loc[np.random.choice(data.index, 1000)]
data3 = data.loc[np.random.choice(data.index, 1000)]
data3 = data3.merge(prices[['ad_id','price_per_hour']])
#del data
#data4 = data.loc[np.random.choice(data.index, 100000)]
##data5 = data.loc[np.random.choice(data.index, 1000000)]
#for d in [data1, data2, data3, data4]:
    #start = datetime.datetime.now()
    #me=CountVectorizer()
    #d=me.fit_transform(d['content'])
    #print('Completed %s in %s, found %s features' % ( d.shape[0], datetime.datetime.now()-start, d.shape[1]))


#no_price = pandas.read_csv('data/temp/ad_ids_no_price.csv')
cv = CountVectorizer()
X = cv.fit_transform(data3['content'])
y = data3['price_per_hour']
out_list = []
if True:
    for n in [100000,500000, 1000000, 2000000]:
        data3 = data.loc[np.random.choice(data.index, n)]
        data3 = data3.merge(prices[['ad_id','price_per_hour']])
        cv = CountVectorizer()
        X = cv.fit_transform(data3['content'])
        y = data3['price_per_hour']
        for thresh in [.001, .0001, .00001, .000001, .0000001]:
        #for thresh in [.001, .0001]:
            out_dict = {}
            out_dict['threshold'] = thresh
            out_dict['N'] = n
            print('Threshold: %s' % thresh)
#print('Score: %s' % score)
            #pipe = Pipeline([
                ##('cv', CountVectorizer()),
                #('select_features', SelectFromModel(RandomForestRegressor(), threshold=.00001)),
                #('output_rf', RandomForestRegressor(oob_score=True, n_jobs=-1)),
            #])
            #results = cross_val_score(pipe,X,y, n_jobs=-1)
            #print('random forest R2 scores from CV: %0.3f' % np.mean(results))
            rf=RandomForestRegressor()
            rf_fitted=rf.fit(X, data3['price_per_hour'])
            sm=SelectFromModel(rf, prefit=True, threshold=thresh)
            X_new=sm.transform(X)
            print('Features: %s' % X_new.shape[1])
            out_dict['n_features'] = X_new.shape[1]
            print('N: %s' % X_new.shape[0])

            rf_new = RandomForestRegressor(oob_score=True)
            results = cross_val_score(rf_new, X_new, y, n_jobs=-1)
            print('RF R2 scores from CV: %0.3f' % np.mean(results))
            out_dict['rf_r2'] = np.mean(results)
            #rf_fitted = rf_new.fit(X_new, data3['price_per_hour'])
            #score=rf_fitted.score(X_new, data3['price_per_hour'])
            #print('Threshold: %s' % thresh)
            #print('Features: %s' % X_new.shape[1])
            #print('Score: %s' % score)
            #lm_pipe = Pipeline([
                ##('cv', CountVectorizer()),
                #('select_features', SelectFromModel(RandomForestRegressor(), threshold=thresh)),
                #('output', LinearRegression( n_jobs=-1)),
            #])
            lm=LinearRegression(n_jobs=-1)
            lm_results = cross_val_score(lm,X_new,y, n_jobs=-1)
            print('LM R2 scores from CV: %0.3f' % np.mean(lm_results))
            out_dict['lm_r2'] = np.mean(lm_results)
            out_list.append(out_dict)

df=pandas.DataFrame(out_list)
ipdb.set_trace()


thresh = .00001
rf=RandomForestRegressor()
rf_fitted=rf.fit(X, data3['price_per_hour'])
sm=SelectFromModel(rf, prefit=True, threshold=thresh)
X_new=sm.transform(X)

#rf_new = RandomForestRegressor(oob_score=True)
#rf_fitted = rf_new.fit(X_new, data3['price_per_hour'])
#score=rf_fitted.score(X_new, data3['price_per_hour'])
print('Threshold: %s' % thresh)
print('Features: %s' % X_new.shape[1])
#print('Score: %s' % score)
pipe = Pipeline([
    #('cv', CountVectorizer()),
    ('select_features', SelectFromModel(RandomForestRegressor(), threshold=.00001)),
    ('output_rf', RandomForestRegressor(oob_score=True, n_jobs=-1)),
])
results = cross_val_score(pipe,X,y, n_jobs=-1)
print('random forest R2 scores from CV: %0.3f' % np.mean(results))
lm_pipe = Pipeline([
    #('cv', CountVectorizer()),
    ('select_features', SelectFromModel(RandomForestRegressor(), threshold=.00001)),
    ('output', LinearRegression( n_jobs=-1)),
])
lm_results = cross_val_score(lm_pipe,X,y, cv=8, n_jobs=-1)
print('LM R2 scores from CV: %0.3f' % np.mean(results))

#pipe_reg = 
from sklearn.linear_model import RandomizedLasso
#pipe_reg = Pipeline(

#pipe.fit(X, y)
#print('Overall score: %s' % pipe.score(X, y))
    ##pipe = Pipeline([('rf_for', rf), ('select',sm), ('output', RandomForestRegressor(oob_score=True))])
#pipe_no_out = Pipeline([
    #('select_features', SelectFromModel(RandomForestRegressor(), threshold=.00001)),
    #('output_rf', RandomForestRegressor(oob_score=False)),
#])

#pipe_no_out.fit(X, y)
#print('Overall score in bag: %s' % pipe_no_out.score(X, y))
