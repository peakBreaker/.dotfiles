#!/usr/bin/env python

import sys
import json
from datetime import datetime, date, time, timedelta

import pandas as pd

CAT = {'AMEDIA': [
    "INTERRUPT", "HOTFIX", "PLANNED_DEV", "LEARN&RESEARCH", "STRAT&PLANNING", "BREAK", "MEETING", "OTHER"
    ],
    }
CAT['WORK'] = CAT['AMEDIA']


def parse_date(d):
    # Example: '2018-10-08T09:12:16+02:00'
    d = datetime.strptime(d, '%Y-%m-%dT%H:%M:%S%z')
    d = d.replace(tzinfo=None)
    return d


def parse_tags(row):
    "Splits the tags into columns"
    for idx, u in enumerate(CAT.get(row['project'], {})):
        if u in row['tags']:
            return CAT[row['project']][idx]
    return None


def elapsed(tf):
    "Calculates overall timeframe and elapsed within"

    # First get the overall stretch
    first = tf.iloc[[0]]['start'].iloc[0]
    last = tf.iloc[[-1]]['stop'].iloc[0]
    whole = last - first
    print('ELAPSED: From first to last in tf: %s' % whole)

    # Next we apply a lambda to calc elapsed for each frame and return
    tf['Elapsed'] = tf.apply(lambda r: r['stop'] - r['start'], axis=1)
    print(tf)
    return tf


def get_timeframes(df, start, end):
    'segments out the time tracked between start & end'
    print('Calculating for')
    print("%s to %s" % (start, end))
    # Calc in cases where the frame stretches mult days
    df.loc[(df['stop'] > start) & (df['start'] < start), 'start'] = start
    df.loc[(df['stop'] > end) & (df['start'] < end), 'stop'] = end
    # get all the frames
    df = df[(df['start'] >= start) & (df['stop'] <= end)]
    print(df)
    return df


def main():

    # First get the data on stdin
    data = sys.stdin.read()

    # Parse the data
    print('Main: Parsing data..', end='')
    timeData = json.loads(data)
    print('OK!')

    # print('Main: Initial DF')
    dft = pd.DataFrame(timeData)
    # print(dft.tail(1))
    # print(dft.dtypes)
    print('MAIN: Setting unique tags')
    dft['UniqueTag'] = dft.apply(parse_tags, axis=1)
    print(dft)

    print('Main: After dateparsing')
    dft['start'] = dft['start'].apply(parse_date)
    dft['stop'] = dft['stop'].apply(parse_date)
    print(dft.tail(5))
    print(dft.dtypes)

    today = date.today()
    tomorrow = datetime.combine(today+timedelta(days=1), time())
    yest = datetime.combine(today+timedelta(days=-1), time())
    today = datetime.combine(today, time(hour=11))
    # tf = get_timeframes(dft, today, tomorrow)
    tf = get_timeframes(dft, yest, today)
    # Calculate elapsed
    print('Getting last row:')
    print('Calculating elapsed:')
    elapsed(tf)
    sumtime = tf['Elapsed'].sum()
    tf['PercTime'] = tf.apply(lambda r: 100 * r['Elapsed'] / sumtime, axis=1)
    print(tf)


if __name__ == '__main__':
    main()


