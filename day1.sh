#!/bin/bash

dial=50
password=0

while read line; do 
    rotate=${line:0:1}
    times=${line:1}

    case "$rotate" in
        R)
            ((dial += times))
            while [[ dial -ge 100 ]]; do
                ((dial -= 100))
            done
            ;;
        L)
            ((dial -= times))
            while [[ dial -lt 0 ]]; do
                ((dial +=100))
            done
            ;;
    esac

    if [[ dial -eq 0 ]]; then
        ((password++))
    fi

done < $1

echo "The password is: $password."
