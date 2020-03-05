#!/usr/bin/env python3

import sys
from pandas.plotting import register_matplotlib_converters
import matplotlib.pyplot as plt
import matplotlib.dates as mdates
import pandas as pd

register_matplotlib_converters()

# ticks formaters
years = mdates.YearLocator()   # every year
months = mdates.MonthLocator()  # every month
weeks =  mdates.WeekdayLocator() # every week
monthFmt = mdates.DateFormatter('%d-%m-%Y')

# read data
data = pd.read_csv(sys.stdin,sep=' ', header=0)
data['date'] = pd.to_datetime(data['date'])

# the plot
plt.figure()
plt.plot(data['date'], data['words'], color='r')
plt.xlabel('TIME')
plt.ylabel('THESIS WORD COUNT')
plt.title('THESIS WORD COUNT vs. TIME')


# format the ticks
ax = plt.gca()
ax.xaxis.set_major_locator(months)
ax.xaxis.set_major_formatter(monthFmt)


plt.gcf().autofmt_xdate() # Rotation
# Annotate with text + Arrow
# plt.annotate('CREATED THESIS FILE', xy=(25,50), arrowprops=dict(facecolor='black', shrink=0.05))
plt.savefig('word_count.png')
