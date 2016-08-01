import pandas as pd
import numpy as np
import datetime
from helpers import mean_hourly_rate


def _stat_feature_dict(prefix=''):
    """
    Get dictionary of stat features for use in aggregations
    :param str prefix:
    :returns: `dict` --
    """
    return {prefix+'_count': len,
            prefix+'_mean': np.mean,
            prefix+'_std': np.std,
            prefix+'_ad_p05_msa': lambda x: np.percentile(x, q=5),
            prefix+'_ad_p10_msa': lambda x: np.percentile(x, q=10),
            prefix+'_ad_p15_msa': lambda x: np.percentile(x, q=15),
            prefix+'_ad_p20_msa': lambda x: np.percentile(x, q=20),
            prefix+'_ad_p25_msa': lambda x: np.percentile(x, q=25),
            prefix+'_ad_p30_msa': lambda x: np.percentile(x, q=30),
            prefix+'_ad_p35_msa': lambda x: np.percentile(x, q=35),
            prefix+'_ad_p40_msa': lambda x: np.percentile(x, q=40),
            prefix+'_ad_p45_msa': lambda x: np.percentile(x, q=45),
            prefix+'_ad_p50_msa': lambda x: np.percentile(x, q=50),
            prefix+'_ad_p55_msa': lambda x: np.percentile(x, q=55),
            prefix+'_ad_p60_msa': lambda x: np.percentile(x, q=60),
            prefix+'_ad_p65_msa': lambda x: np.percentile(x, q=65),
            prefix+'_ad_p70_msa': lambda x: np.percentile(x, q=70),
            prefix+'_ad_p75_msa': lambda x: np.percentile(x, q=75),
            prefix+'_ad_p80_msa': lambda x: np.percentile(x, q=80),
            prefix+'_ad_p85_msa': lambda x: np.percentile(x, q=85),
            prefix+'_ad_p90_msa': lambda x: np.percentile(x, q=90),
            prefix+'_ad_p95_msa': lambda x: np.percentile(x, q=95)}


def _calculate_grouped_col_stats(df, grouping_col, stat_col, stat_prefix):
    """

    :param pandas.DataFrame df: Dataframe to analyze
    :param str grouping_col: Column to aggregate
    :param str stat_col: Column on which to calculate stats
    :param str stat_prefix: Prefix to ad to the stat column
    :return:
    """
    grps = df.groupby(grouping_col)
    return grps[stat_col].agg(_stat_feature_dict(stat_prefix))


def _get_quarter(value):
    """

    :param datetime.datetime | datetime.date value:
    :return:
    """
    day = 1
    year = value.year
    month = value.month

    if month < 0 or month > 12:
        month = -1
    elif month < 4:
        month = 1
    elif month < 7:
        month = 4
    elif month < 10:
        month = 7
    else:
        month = 10

    return pd.Timestamp(datetime.date(year, month, day))


class MakeMSA:
    def __init__(self, df):
        self.df = df

    def get_msa_features(self):
        """
        Will get all features related to the msa
        :return: All msa features
        """

        # Since calculating with NaN is problematic and slows down processing,
        # let's create two dataframes.
        # One for rates without NaN and one for ages without NaN
        rate_df = self.df.dropna(subset=['rate'])
        age_df = self.df.dropna(subset=['age'])

        # Calculate the rates by hour and delete the old rate column. Then drop any remaining NaN
        rate_df['rate_per_hour'] = rate_df['rate'].apply(mean_hourly_rate)
        rate_df = rate_df.drop('rate', 1)
        rate_df = rate_df.dropna(subset=['rate_per_hour'])

        # Now do rates and age for city
        city_stats_rate = _calculate_grouped_col_stats(rate_df, 'city', 'rate_per_hour', 'rate')
        city_stats_age = _calculate_grouped_col_stats(age_df, 'city', 'age', 'age')
        city_stats = city_stats_rate.join(city_stats_age, how='outer')

        # Now do rates and age for state
        state_stats_rate = _calculate_grouped_col_stats(rate_df, 'state', 'rate_per_hour', 'rate')
        state_stats_age = _calculate_grouped_col_stats(age_df, 'state', 'age', 'age')
        state_stats = state_stats_rate.join(state_stats_age, how='outer')

        return {'state_stats': state_stats, 'city_stats': city_stats}

    def get_rates(self):
        """
        Creates a dataframe with a new rates column from the rates column
        with comma delimited fields
        :return:
        """
        # Get only rates and msa
        df = self.df[['rate', 'city', 'state']].dropna(0)

        # Calculate the rate per hour
        df['rate_per_hour'] = df['rate'].apply(mean_hourly_rate)

        # We don't need the original rate column anymore
        df = df.drop('rate', 1)

        # Drop the nan values and return
        return df.dropna(0)

    def get_ages(self):
        """

        :return: Data frame with MSA and Age
        """
        # Get only ages and msa
        return self.df[['age', 'city']].dropna(0)

    def plot_prices(self):
        # First get rates, post date and msa
        df = self.df[['rate', 'post_date', 'msa_name']].dropna(0)

        # Calculate the rate per hour
        df['rate_per_hour'] = df['rate'].apply(mean_hourly_rate)

        # Drop nan once more to get rid of prices we couldn't calculate
        df = df.dropna(0)

        # We don't need the original rate column anymore
        df = df.drop('rate', 1)

        # Convert post date column to datetime
        df['post_date'] = pd.to_datetime(df['post_date'], format='%Y-%m-%d')

        # Change the date to represent quarters
        df['post_date'] = df['post_date'].apply(_get_quarter)

        # Group by msa and post date
        df = df.groupby(['msa_name', 'post_date']).filter(lambda x: len(x) > 300)

        # Find the msa with the proper amount of rates

        df['test'] = df['']

    """ **** CURRENTLY NOT USED***
    def get_incall_outcall(self):
        # First get only the service and msa from the dataframe
        df = self.df[['service', 'msa_name']]

        # Group by msa
        group_by_msa = df.groupby('msa_name')

        # Get the percentage with incall
        group_by_msa_incall = df[df['service'].str.contains("incall")==True].groupby('msa_name').size() / group_by_msa.size()

        # Get the percentage with outcall
        group_by_msa_outcall = df[df['service'].str.contains("outcall")==True].groupby('msa_name').size() / group_by_msa.size()"""
