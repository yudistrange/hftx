#!/usr/bin/env python3

import datetime
import pandas as pd
from dateutil.relativedelta import relativedelta
import yfinance as yf

def download(symbol="BAJFINANCE.NS", fname="download.csv"):
    sdate = datetime.date.today() - datetime.timedelta(days=30)
    edate = datetime.date.today()
    print(sdate)
    print(edate)
    smonday = sdate + datetime.timedelta(days=-sdate.weekday(), weeks=1)
    sfriday = smonday + datetime.timedelta(days=5)

    start = smonday
    end = sfriday

    while(start < edate and end < edate):
        bj_download = yf.download(symbol, start=start, end=end, interval="1m")
        print(bj_download)
        bj_download.to_csv(path_or_buf=fname, mode="a")
        start = start + datetime.timedelta(weeks=1)
        end = end + datetime.timedelta(weeks=1)

if __name__ == "__main__":
   download()
