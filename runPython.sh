#!/bin/bash

# untar your Python installation. Make sure you are using the right version!
tar -xzf python310.tar.gz
# (optional) if you have a set of packages (created in Part 1), untar them also
tar -xzf packages.tar.gz

# make sure the script will use your Python installation, 
# and the working directory as its home location
export PATH=$PWD/python/bin:$PATH
export PYTHONPATH=$PWD/packages
export HOME=$PWD

link=$1
wget "$link"
if [ $? -eq 0 ] && [ -e "$(basename "$link")" ]; then
    # Run your script
    python3 analysis.py "$(basename "$link")"
    rm "$(basename "$link")"
else
    # If wget failed or output file does not exist, stop the script
    echo "Invalid link or wget failed. Exiting..."
    exit 1
fi
