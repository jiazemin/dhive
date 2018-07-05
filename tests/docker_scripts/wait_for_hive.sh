#!/usr/bin/env bash

wait_for_hive () {
    # Wait for port to open
    counter=0
    while [ 1 ]
    do
        curl hs2.example.com:10000
        if [ $? -eq 0 ]; then
          break
        fi
        counter=$((counter+1))
        if [[ "$counter" -gt 12 ]]; then
          # Just fail because the port didn't open
          exit 1
        fi
        echo "Waiting for hive port to open"
        sleep 10
    done
}

wait_for_hive
echo "Finished OK"
