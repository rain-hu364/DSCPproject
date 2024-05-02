#!/bin/bash

cat lyft_avg_wait_2019_02.csv > mergedLyft.csv

for f in lyft_avg_wait*.csv; do
    if [ "$f" != "lyft_avg_wait_2019_02.csv" ]; then
        tail -n +2 "$f" >> mergedLyft.csv
    fi
done
