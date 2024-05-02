#!/bin/bash

cat summary_2019_02.csv > mergedSummary.csv

for f in summary*.csv; do
    if [ "$f" != "summary_2019_02.csv" ]; then
        tail -n +2 "$f" >> mergedSummary.csv
    fi
done
