#!/bin/bash

#Change the base_url the type of trip (yellow, green, fhvhv, fhv), change the year to whatever year you want to download
#Make sure you have download_data.sh in the year/type_of_trip/   folder
#This will download all 12 months for that year for the specific type of trip
#If you can change it to where you can just run it once and it puts the files into their folders than it would make it more efficent but this worked for me
#I picked 2019-2023 because that is when we got hvfhv data

base_url="https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2019-"

for ((i = 1; i <= 12; i++)); do
    url="${base_url}$(printf "%02d" $i).parquet"

    wget "$url"
done
