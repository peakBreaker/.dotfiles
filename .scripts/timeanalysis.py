#!/usr/bin/env python

import sys
import json
from datetime import datetime, date, time, timedelta

import pandas as pd

# Constants
ANALYSIS_FRAME_DAYS = 1
START_DATE = date(2018, 10, 5)

# Construct our main data collections
main_dfs = {
       'WORK': pd.DataFrame(columns=["INTERRUPT", "HOTFIX", "PLANNED_DEV",
                                     "LEARN&RESEARCH", "STRAT&PLANNING",
                                     "BREAK", "MEETING", "OTHER"]),
       'CLIENT': pd.DataFrame(columns=["SENS_MEET", "SENS_DEV"]),
       'PERS': pd.DataFrame(columns=["EXERCISE", "COURSES", "READING"]),
       'LIFE': pd.DataFrame(columns=["LEISURE", "MORNING_ROUTINE"]),
       'OTHER': pd.DataFrame(columns=["OTHER", "ERROR"])
      }

for p in main_dfs.keys():
    main_dfs[p]['date'] = (START_DATE,)
    main_dfs[p]['datetime'] = pd.to_datetime(main_dfs[p]['date'])
    main_dfs[p].set_index('datetime', inplace=True)
    main_dfs[p].drop(['date'], axis=1, inplace=True)

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

    # Calculate the valid indexes
    if project is None:
        idx_selector = (0, -1)
    else:
        idx_selector = [i for i in range(len(
                        tf.index[tf['project'] == project].tolist()))]

    # Check that the tf or idx selector is empty
    if tf.empty or idx_selector == []:
        return 0

    s_col, e_col = (idx_selector[0], idx_selector[-1])  # Clever, eh?

    # Calculate the time between first and last valid row
    first = tf.iloc[[s_col]]['start'].iloc[0]
    last = tf.iloc[[e_col]]['stop'].iloc[0]
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
    print('Checking if %s and %s is in dataframe.. ' % (u, p), end='')
    if u not in _df['UniqueTag'].values or p not in _df['project'].values:
        print('Nope!')
        return 0
    else:
        print('Yep!')
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

    # Iterate and analyze per day
    print('Analyzing from date: %s' % START_DATE)
    d_ptr = datetime.combine(START_DATE, time())

    while d_ptr < datetime.today():
        # First increment the nxt pointer
        d_nxt = datetime.combine(d_ptr+timedelta(days=ANALYSIS_FRAME_DAYS), time())

        # Next up we get the dataframe for the given day
        tf = get_timeframes(df, d_ptr, d_nxt)
        for p in main_dfs.keys():
            whole = elapsed(tf, p)
            print('Elapsed for %s :: %s' % (d_ptr, whole))
            main_dfs[p].iloc[d_ptr]

            columns=[u for u in list(main_dfs[p])


        # Finally incr the date pointer by setting it to the nxt pointer
        d_ptr = d_nxt

    return

    # today = date.today()
    # tomorrow = datetime.combine(today+timedelta(days=1), time())
    # yest = datetime.combine(today+timedelta(days=-1), time())
    # today = datetime.combine(today, time(hour=11))
    # tf = get_timeframes(dft, today, tomorrow)

    # Calculate elapsed
    print('Getting last row:')
    print('Calculating elapsed:')
    elapsed(tf)
    sumtime = tf['Elapsed'].sum()
    tf['PercTime'] = tf.apply(lambda r: 100 * r['Elapsed'] / sumtime, axis=1)
    print(tf)

    # Group by project and uniquetag, start by making our result df
    # TODO: Rework to use multi-index


    e_df['Elapsed'] = e_df.apply(groupdf, axis=1, args=(tf,))
    print(e_df)

if __name__ == '__main__':
    main()
