#!/bin/bash

#for year in {2014..2023}; do
#    for month in {1..12}; do
#	link="https://d37ci6vzurychx.cloudfront.net/trip-data/fhv_tripdata_$year-$month.parquet"
#        echo "$link" >> parquetList
#    done
#done


for ((i = 2019; i <= 2023; i++)); do
    for ((j = 1; j <= 12; j++)); do
	base_url="https://d37ci6vzurychx.cloudfront.net/trip-data/fhvhv_tripdata_$i-"
	url="${base_url}$(printf "%02d" $j).parquet"
	echo "$url" >> parquetLinksList
    done
done
