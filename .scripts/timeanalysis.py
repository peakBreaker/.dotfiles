#!/usr/bin/env python

import sys
import json
from datetime import datetime, date, time, timedelta

import pandas as pd

def parse_date(d):
    # Example: '2018-10-08T09:12:16+02:00'
    d = datetime.strptime(d, '%Y-%m-%dT%H:%M:%S%z')
    d = d.replace(tzinfo=None)
    return d

def calc_elapsed(start, end):
    e = parse_date(end) - parse_date(start)
    print('Elapsed: Calculated elapsed time')
    print(e)

def parse_tags(data):
    "Splits the tags into columns"
    pass
# ---

CAT = {'AMEDIA': [
    "INTERRUPT", "HOTFIX", "PLANNED_DEV", "LEARN&RESEARCH", "STRAT&PLANNING", "BREAK", "MEETING", "OTHER" 
    ]}

def get_timeframes(df, start, end):
    'segments out the time tracked between start & end'
    print('Calculating for')
    print("%s to %s" % (start, end))
    # Calc in cases where the frame stretches mult days
    df.loc[(df['stop'] > start) & (df['start'] < start), 'start'] = start
    df.loc[(df['stop'] < end) & (df['start'] > end), 'stop'] = end
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

    print('Main: After dateparsing')
    dft['start'] = dft['start'].apply(parse_date)
    dft['stop'] = dft['stop'].apply(parse_date)
    print(dft.tail(5))
    print(dft.dtypes)
    
    today = date.today()
    tomorrow = datetime.combine(today+timedelta(days=1), time())
    today = datetime.combine(today, time(hour=11))
    tf = get_timeframes(dft, today, tomorrow)
    print(tf)

if __name__ == '__main__':
    main()


