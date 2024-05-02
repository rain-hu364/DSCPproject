#!/bin/bash

cat uber_avg_wait_2019_02.csv > mergedUber.csv

for f in uber_avg_wait*.csv; do
    if [ "$f" != "uber_avg_wait_2019_02.csv" ]; then
        tail -n +2 "$f" >> mergedUber.csv
    fi
done
