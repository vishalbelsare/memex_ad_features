import pandas
import datetime
import ipdb
import json
import numpy as np
from sklearn import linear_model
from sklearn import datasets

msa_month_features = pandas.read_csv('all_merged.csv')
data = pandas.read_csv('normalized_prices.csv')
if False:
    msa = pandas.read_csv('forGiantOak/msa_locations.tsv.gz', sep='\t', header=None, compression='gzip', names=['ad_id','census_msa_code'])
    ts = pandas.read_csv('forGiantOak/doc-provider-timestamp.tsv.gz', sep='\t', header=None, compression='gzip', names=['ad_id','cluster','date_str'])
else:
    msa = pandas.read_csv('forGiantOak/msa_locations.tsv', sep='\t', header=None, names=['ad_id','census_msa_code'])
    ts = pandas.read_csv('forGiantOak/doc-provider-timestamp.tsv', sep='\t', header=None, names=['ad_id','cluster','date_str'])
data = pandas.merge(data,ts)
data= data[data['date_str'] != '\N']
data['date'] = data['date_str'].apply(lambda x: datetime.datetime.strptime(x, '%Y-%m-%d %H:%M:%S' ))
data.index = pandas.DatetimeIndex(data['date']) 
data.reindex(inplace=True)
##out=data.resample('M', how='mean')
# Progress; Need to resample both counts and prices to the monthly
# level. But first want to merge in actual data so we don't average the
# wrong thing. Then we merge these counts into the all_merged data at
# the month-msa level
# Begin aggregating ad level data up to the MSA-month level
ad_level = pandas.DataFrame(data.groupby('ad_id')['price_per_hour'].mean())
ad_level['ad_id'] = ad_level.index
ad_level.drop_duplicates('ad_id', inplace=True)
ad_level = pandas.merge(ad_level, msa, left_index=True, right_on='ad_id') # Note: we drop lots of ads with price  but not MSA
# NOTE: at this point we grow with a merge instead of shrinking. This is
# because we have more than one msa per ad
ad_level = pandas.merge(ad_level, data[['ad_id','date']])
ad_level['month'] = ad_level['date'].apply(lambda x: int(x.strftime('%m')))
ad_level['year'] = ad_level['date'].apply(lambda x: int(x.strftime('%Y')))



#ad_level = pandas.merge(ad_level, msa_month_features, how='left')
month_msa_aggregate_prices = ad_level.groupby(['month','year','census_msa_code'])['price_per_hour'].aggregate({'ad_median':np.median, 'ad_count':len,'ad_mean':np.mean, 'ad_p50':lambda x: np.percentile(x,q=50), 'ad_p10':lambda x: np.percentile(x, q=10), 'ad_p90':lambda x: np.percentile(x, q=90)})
month_msa_aggregates_with_features = pandas.merge(month_msa_aggregate_prices, msa_month_features, left_index=True, right_on=['month','year','census_msa_code'])
month_msa_aggregate_prices.to_csv('ad_prices_msa_month.csv', index=False)
# Code below here creates a pandas "Panel" object
j=month_msa_aggregates_with_features.copy()
j.reset_index(inplace=True)    
j['date_str'] = j.apply(lambda x: str(x['month']) + '-' + str(x['year']), axis=1)   
import datetime
j['dp']=j['date_str'].apply(lambda x: pandas.Period(x, 'M'))
subset = j[['dp','census_msa_code']]
subset.to_records(index=False).tolist()
index = pandas.MultiIndex.from_tuples(subset.to_records(index=False).tolist(), names=subset.columns.tolist())
j.index = index
j.reindex()
j.rename(columns={'female_mean.wage':'female_mean','male_mean.wage':'male_mean','female_sum.wght':'female_num_jobs', 'male_sum.wght':'male_num_jobs'}, inplace=True)
panel = j.to_panel()
# Panel is our panel object
diff_cols = ['female_p25','female_p50','female_p75','male_p25','male_p50','male_p75', 'female_num_jobs','male_num_jobs','female_mean','male_mean', 'ad_p10', 'ad_p50', 'ad_p90', 'ad_mean', 'ad_count']
for col in diff_cols:
    panel['d_' + col] = panel[col] - panel[col].shift(-1)
    panel['d_%s_pos'% col] = panel['d_' + col] > 0 # Generate dummies for positive and negative changes
# Use panel functionality to take first differences

panel.to_frame().to_csv('monthly_panel.csv')