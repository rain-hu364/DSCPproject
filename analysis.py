#import library
import pandas as pd
import re
from datetime import datetime
import sys

#import data
args = sys.argv[1:]
if len(args) != 1:
    sys.exit("Usage: python script.py <file path>")
arg1 = args[0]
#arg1 = "https://d37ci6vzurychx.cloudfront.net/trip-data/fhvhv_tripdata_2019-10.parquet"
pattern = r'(\d{4})-(\d{2})'
match = re.search(pattern, arg1)
year = match.group(1)
month = match.group(2)
order = (int(year)-2019)*12 + int(month)
raw_df = pd.read_parquet("fhvhv_tripdata_" + year+ "-" + month +".parquet")

# compare Uber and Lyft on their average driver_pay and tips
# parallel job: run this for all the month in 2019-2023, generate a csv file that contains the average trip miles, trip distance, tips, driver pay, and tips proportion for Uber and Lyber;
# index by their order in the total 60 month. (eg. the index for 2019-01 is 1 and for 2020-01 is 13)
# after the parallel job, we should have 60 csv. Merge them together and graph the changes within time & overall pattern
df = raw_df[['hvfhs_license_num','trip_miles','trip_time', 'tips','driver_pay']]
df = df[(df['hvfhs_license_num']== 'HV0003') | (df['hvfhs_license_num']== 'HV0005')]
df = df.dropna()
license_to_company = {
    'HV0003': 'Uber',
    'HV0005': 'Lyft'}
df['hvfhs_license_num'] = df['hvfhs_license_num'].map(license_to_company)
df.rename(columns={'hvfhs_license_num': 'company'}, inplace=True)
tips_prop = df.groupby('company')['tips'].apply(lambda x: (x > 0).mean())
tip_df = df[df['tips']!=0]
df_summary = tip_df.groupby('company').mean()
df_summary['tips_propotion'] = tips_prop
df_summary['index'] = order
df_summary.to_csv("summary_"+year+"_"+month+".csv", index=True)

# analyze buzy area in NYC based on the time it takes to get picked up after requesting a ride.
# parallel job: for each month, calculate the average wait time for each area code. 
# after parallel job: take the average for all 60 csv and look at the top 10 - 15 most busy area, graph them with NYC Taxi Zone shapefile on the data page.
# Data Page: https://www.nyc.gov/site/tlc/about/tlc-trip-record-data.page
time_df = raw_df[["request_datetime", "hvfhs_license_num","pickup_datetime", "PULocationID"]]
time_df = time_df[(time_df['hvfhs_license_num']== 'HV0003') | (time_df['hvfhs_license_num']== 'HV0005')]
license_to_company = {
    'HV0003': 'Uber',
    'HV0005': 'Lyft'}
time_df['hvfhs_license_num'] = time_df['hvfhs_license_num'].map(license_to_company)
time_df.rename(columns={'hvfhs_license_num': 'company'}, inplace=True)
date_format = "%Y-%m-%d %H:%M:%S"

time_df["request_datetime"] = pd.to_datetime(time_df["request_datetime"], format=date_format)
time_df["pickup_datetime"] = pd.to_datetime(time_df["pickup_datetime"], format=date_format)

time_df["wait_min"] = (time_df["pickup_datetime"] - time_df["request_datetime"]).dt.seconds // 60
time_df = time_df[time_df["wait_min"]<=18]
mean_wait = time_df.groupby(["company","PULocationID"])["wait_min"].mean()

avg_wait = pd.DataFrame(mean_wait)
avg_wait.reset_index(inplace=True)
lyft_avg_wait = avg_wait[avg_wait['company']=="Lyft"]
lyft_avg_wait.to_csv("lyft_avg_wait_" + year+"_"+month+".csv", index=False)
uber_avg_wait = avg_wait[avg_wait['company']=="Uber"]
uber_avg_wait.to_csv("uber_avg_wait_" + year+"_"+month+".csv", index=False)
