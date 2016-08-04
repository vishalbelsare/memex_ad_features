import pandas as pd
from helpers import mean_hourly_rate_df
from tqdm import tqdm

quantiles = ['rate_ad_p{}_msa'.format(str(i).zfill(2))
             for i in range(5, 96, 5)]


def _calculate_quantile_relative_loc(x):
    """
    Gets the quantile the rate is in
    :param x: slice from pandas.DataFrame
    :returns: `int` -- Quantile of rate
    """
    try:
        return np.searchsorted(x[quantiles], x['rate_per_hour'])[0]
    except (IndexError, ValueError):
        return np.nan


class MakeAd:
    def __init__(self, city_features, state_features, ad_df):
        self.city_features = city_features
        self.state_features = state_features
        self.ad_df = ad_df

    def get_ad_features(self):
        """
        Will get the specified ad features
        :returns: `pandas.DataFrame` -- Dataframe containing ad features
        """
        # Since we need the rate to do any calculations
        # drop all values from the ad that do not have a rate
        df = self.ad_df.dropna(subset=['rate'])

        # Calculate the rate per hour
        # then drop the old rate column and get rid of NaN values
        df = df.\
            merge(mean_hourly_rate_df(df),
                  left_on=['_id'], right_on=['_id']).\
            drop('rate', axis=1).\
            drop_duplicates()

        # Since we just got rid of the rate column, let's drop the duplicates
        df.drop_duplicates(inplace=True)

        # city calcs
        city_df = df.dropna(subset=['city']).\
            loc[:, ['_id', 'rate_per_hour', 'city_wikidata_id']].\
            merge(self.city_features.loc[:, ['city_wikidata_id'] +
                                            ['rate_mean', 'rate_std'] +
                                            quantiles],
                  left_on=['city_wikidata_id'], right_on=['city_wikidata_id'])

        city_df['relative_price_to_city'] = \
            (city_df.rate_per_hour - city_df.rate_mean) / city_df.rate_std

        tqdm.pandas(desc='relative_quantile_to_city')
        city_df['relative_quantile_to_city'] = \
            city_df.loc[:, ['rate_per_hour'] + quantiles].progress_apply(
                _calculate_quantile_relative_loc, axis=1)

        city_df = city_df.loc[:, ['_id',
                                  'relative_price_to_city',
                                  'relative_quantile_to_city']]

        # state calcs
        state_df = df.dropna(subset=['state']). \
            loc[:, ['_id', 'rate_per_hour', 'state_wikidata_id']]. \
            merge(self.state_features.loc[:, ['state_wikidata_id'] +
                                             ['rate_mean', 'rate_std'] +
                                             quantiles],
                  left_on=['state_wikidata_id'], right_on=['state_wikidata_id'])

        state_df['relative_price_to_state'] = \
            (state_df.rate_per_hour - state_df.rate_mean) / state_df.rate_std

        tqdm.pandas(desc='relative_quantile_to_state')
        df['relative_quantile_to_state'] = df.progress_apply(
            lambda x: self.calculate_quantile_relative_loc(x['rate_per_hour'],
                                                           'state',
                                                           x['state']),
            axis=1)

        state_df = state_df.loc[:, ['_id',
                                    'relative_price_to_state',
                                    'relative_quantile_to_state']]

        # Merge city and state calcs and return
        return df.\
            merge(city_df, left_on=['_id'], right_on=['_id'], how='left').\
            merge(state_df, left_on=['_id'], right_on=['_id'], how='left')

    def calculate_price_relative_loc(self, rate, loc_type, loc_name):
        """
        Returns the rate relative to the location's rates
        :param float rate:
        :param str loc_type:
        :param str loc_name:
        :returns: `float` --
        """
        if pd.isnull(loc_name):
            return None

        if loc_type == 'city':
            df = self.city_features.loc[self.city_features.city == loc_name]
        elif loc_type == 'state':
            df = self.state_features.loc[self.state_features.state == loc_name]
        else:
            return None

        # (Price - mean) / standard deviation
        if df.empty:
            return None
        else:
            relative_price = (rate - df.iloc[0]['rate_ad_p50_msa']) / df.iloc[0]['rate_std']
            return relative_price

    def calculate_quantile_relative_loc(self, rate, loc_col, loc_name):
        """
        Gets the quantile the rate is in
        :param float rate: Rate of the ad
        :param str loc_col: Location column to use
        :param str loc_name: name of the location for the specified rate
        :returns: `int` -- Quantile of rate
        """
        if pd.isnull(loc_name):
            return None

        if loc_col == 'city':
            df = self.city_features.loc[self.city_features.city == loc_name]
        elif loc_col == 'state':
            df = self.state_features.loc[self.state_features.state == loc_name]
        else:
            return None

        if df.empty:
            return None
        else:
            return (df.iloc[0][quantiles].searchsorted(rate)[0] + 1) * 5
