#!/bin/bash
BASE_DIR="/path/to/years"

for YEAR in {2009..2013}; do
     YEAR_DIR="${BASE_DIR}/${YEAR}"
    echo "Processing year: ${YEAR}"

    for TAXI_TYPE in $(ls $YEAR_DIR); do
        TAXI_DIR="${YEAR_DIR}/${TAXI_TYPE}"
        echo "Processing taxi type: ${TAXI_TYPE}"

        echo "Combining files for ${TAXI_TYPE} in year ${YEAR}"
            pqcat "${TAXI_DIR}/${TAXI_TYPE}_tripdata_${YEAR}-"*.parquet > "${TAXI_DIR}/combined_${TAXI_TYPE}_${YEAR}.parquet"
    done
done

echo "All files processed."
