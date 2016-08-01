import pandas as pd
from helpers import mean_hourly_rate

quantiles = ['rate_ad_p{}_msa'.format(str(i).zfill(2))
             for i in range(5, 96, 5)]


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
        id_groups = df.groupby('_id')
        per_hour_df = id_groups['rate'].apply(
            lambda x: mean_hourly_rate(list(x))).dropna().reset_index()
        per_hour_df.columns = ['_id', 'rate_per_hour']
        df = df.merge(per_hour_df, how='inner')
        del per_hour_df

        # Now get relative price
        df['relative_price_to_city'] = df.apply(
            lambda x: self.calculate_price_relative_loc(x['rate_per_hour'],
                                                        'city',
                                                        x['city']),
            axis=1)

        df['relative_price_to_state'] = df.apply(
            lambda x: self.calculate_price_relative_loc(x['rate_per_hour'],
                                                        'state',
                                                        x['state']),
            axis=1)

        # Now get relative quantile
        df['relative_quantile_to_city'] = df.apply(
            lambda x: self.calculate_quantile_relative_loc(x['rate_per_hour'],
                                                           'city',
                                                           x['city']),
            axis=1)
        df['relative_quantile_to_state'] = df.apply(
            lambda x: self.calculate_quantile_relative_loc(x['rate_per_hour'],
                                                           'state',
                                                           x['state']),
            axis=1)

        return df

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
        relative_price = (rate - df.loc[0, 'rate_ad_p50_msa']) / df.loc[0, 'rate_std']
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
            df = self.state_features.loc[self.state_features.sate == loc_name]
        else:
            return None

        return (df.loc[0, quantiles].searchsorted(rate)[0] + 1) * 5
