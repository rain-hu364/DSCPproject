#!/bin/bash



for year in {2019..2023}; do
	for trip in yellow green fhv fhvhv; do
		for file in /workspace/haertle/project/data/year/${year}/${trip}/*.parquet; do
        		cat "$file" >> /workspace/haertle/project/data/${trip}/combined_${trip}.parquet
		done
	done
done

