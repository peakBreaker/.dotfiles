#!/usr/bin/env python

import sys
import json
from datetime import datetime, date, time, timedelta

import pandas as pd

# Constants
ANALYSIS_FRAME_DAYS = 1
START_DATE = date(2019, 3, 1)
STRF_FORMAT = '%Y-%m-%d'
REPORTS_FOLDER = './reports/'

# Construct our main data collections
specifics = {'WORK': ["1-57-GA", "1-72-AIRFLOW_MIGRATION", "DS1-9-ABTESTER", "ASM1-115-ETL", "4-GCOAT", "0-ADP-RTE", "DS2-EILI"],
             'CLIENT': [],
             'PERS': [],
             'LIFE': [],
             'OTHER': [],
             }
main_dfs = {
       'WORK': pd.DataFrame(columns=["INTERRUPT", "HOTFIX", "PLANNED_DEV",
                                     "LEARN&RESEARCH", "STRAT&PLANNING", "TOOLS",
                                     "SUPPORT", "BREAK", "MEETING", "OTHER",
                                     *[s for s in specifics['WORK']]]),
       'CLIENT': pd.DataFrame(columns=["SENS_MEET", "SENS_DEV"]),
       'PERS': pd.DataFrame(columns=["EXERCISE", "COURSES", "READING", "DEVENV"]),
       'LIFE': pd.DataFrame(columns=["LEISURE", "MORNING_ROUTINE"]),
       'OTHER': pd.DataFrame(columns=["OTHER", "ERROR"])
      }

# Create the datetime index for each dataframe
for p in main_dfs.keys():
    main_dfs[p]['date'] = (datetime.combine(START_DATE, time()),)
    #print(main_dfs[p])
    main_dfs[p]['datetime'] = pd.to_datetime(main_dfs[p]['date'])
    main_dfs[p].set_index('datetime', inplace=True)
    main_dfs[p].drop(['date'], axis=1, inplace=True)
    # print(START_DATE.strftime(STRF_FORMAT))
    # print(main_dfs[p])
    # print(main_dfs[p].loc[START_DATE.strftime(STRF_FORMAT)])


def parse_date(d):
    # Example: '2018-10-08T09:12:16+02:00'
    d = datetime.strptime(d, '%Y-%m-%dT%H:%M:%S%z')
    d = d.replace(tzinfo=None)
    return d


def parse_tags(row):
    "Splits the tags into columns"
    for u in list(main_dfs.get(row['project'], [])):
        if u in row['tags']:
            return u
    return None


def elapsed(tf, project=None):
    "Calculates overall elapsed from start to fin over a timeframe"
    # First sort the df
    if not tf.empty:
        tf = tf.sort_values(by='start')

    # Calculate the valid indexes
    if project is None:
        idx_selector = (0, -1)
    else:
        idx_selector = [i for i in range(len(
                        tf.index[tf['project'] == project].tolist()))]

    # Check that the tf or idx selector is empty
    if tf.empty or idx_selector == []:
        # print('index selector empty!')
        return 0

    s_col, e_col = (idx_selector[0], idx_selector[-1])  # Clever, eh?

    # Calculate the time between first and last valid row
    first = tf.iloc[[s_col]]['start'].iloc[0]
    last = tf.iloc[[e_col]]['stop'].iloc[0]
    # print(tf)
    # print('ELAPSED: calculated elapsed :: %s - %s = %s' % (last, first, str(last-first)))
    return last - first


def get_timeframes(df, start, end):
    'segments out the time tracked between start & end'
    # Calc in cases where the frame stretches mult days
    df.loc[(df['stop'] > start) & (df['start'] < start), 'start'] = start
    df.loc[(df['stop'] > end) & (df['start'] < end), 'stop'] = end
    # get all the frames
    df = df[(df['start'] >= start) & (df['stop'] <= end)]
    return df


def groupdf(row, _df):
    """Groups by project and tag,
    - takes a row from labeled df
    - Dataframe with timedata

      Typical use is applying to label df and passing time df as args
    """
    u, p = (row['UniqueTag'], row['project'])

    # Filter
    # print('Checking if %s and %s is in dataframe.. ' % (u, p), end='')
    if u not in _df['UniqueTag'].values or p not in _df['project'].values:
        # print('Nope!')
        return 0
    else:
        # print('Yep!')
        return _df[(_df['UniqueTag'] == u) & (_df['project'] == p)]['Elapsed'].sum()


def main():

    # First get and parse data from stdin
    df = pd.DataFrame(json.loads(sys.stdin.read()))

    # Parse uniquetags and time to datetime objects
    df['UniqueTag'] = df.apply(parse_tags, axis=1)
    df['start'] = df['start'].apply(parse_date)
    df['stop'] = df['stop'].apply(parse_date)
    df['Elapsed'] = df.apply(lambda r: r['stop'] - r['start'], axis=1)

    # Create the results dataframe
    # e_df = pd.DataFrame(columns=['project', 'UniqueTag', 'Elapsed'])
    # for proj, unique in CAT.items():
        # _df = pd.DataFrame([[proj, u] for u in unique], columns=['project', 'UniqueTag'])
        # e_df = e_df.append(_df, ignore_index=True)
    # print(e_df)

    for p in main_dfs.keys():
        #print('Analyzing dataframe for project :: %s' % p)
        # Construct the columns
        u_meta = ['TOTAL', 'UNACCOUNTED']
        uniques = [u for u in list(main_dfs[p])] + u_meta
        u_prc = [u + '_prc' for u in uniques]

        # Iterate and analyze per day
        # print('Analyzing from date: %s' % START_DATE)
        d_ptr = datetime.combine(START_DATE, time())

        t_data = {}
        print("Analyzing from date :: %s" % d_ptr)
        while d_ptr < datetime.today():
            #print('Analyzing time spent for %s' % d_ptr)
            # First increment the nxt pointer
            d_nxt = datetime.combine(d_ptr+timedelta(days=ANALYSIS_FRAME_DAYS), time())

            # Next up we filter the timeframe by date
            tf = get_timeframes(df, d_ptr, d_nxt)

            # And by project
            tf = tf[(tf['project'] == p)]

            tot_tracked = tf['Elapsed'].sum() if not tf.empty else 0
            start_to_end = elapsed(tf)

            # Calculate the time per unique for the project
            t_data[d_ptr] = [tf[tf['UniqueTag'] == u]['Elapsed'].sum()
                             for u in uniques]
            t_data[d_ptr][uniques.index('UNACCOUNTED')] = start_to_end - \
                tot_tracked
            t_data[d_ptr][uniques.index('TOTAL')] = start_to_end

            # Calculate the percentages
            if tf.empty:
                t_data[d_ptr] += [0 for u in uniques]
            else:
                t_data[d_ptr] += [tf[tf['UniqueTag'] == u]['Elapsed'].sum()*100 /
                                  start_to_end for u in uniques]
            t_data[d_ptr][len(uniques) + u_prc.index('UNACCOUNTED_prc')] = (
                start_to_end - tot_tracked) * 100 / start_to_end if not tf.empty else 0
            t_data[d_ptr][len(uniques) + u_prc.index('TOTAL_prc')] = 100
            # Finally incr the date pointer by setting it to the nxt pointer
            d_ptr = d_nxt

        # Add it to the main df
        main_dfs[p] = pd.DataFrame.from_dict(t_data, orient='index', columns=uniques+u_prc)
        print(main_dfs[p].head())
        # Finally save the project dataframe
        main_dfs[p].to_csv(REPORTS_FOLDER + ('/%s.csv' % p))

if __name__ == '__main__':
    main()
