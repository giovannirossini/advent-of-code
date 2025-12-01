#!/bin/bash

dial=50
password=0
passed=0

while read line; do 
    rotate=${line:0:1}
    times=${line:1}

    case "$rotate" in
        R)
            for ((i = 0; i < times; i++)); do
                ((dial -= 1))
                if [[ dial -eq 0 ]]; then
                    ((passed++))
                fi

                if [[ dial -lt 0 ]]; then
                    ((dial += 100))
                fi
            done
            ;;
        L)
            for ((i = 0; i < times; i++)); do
                ((dial += 1))
                if [[ dial -ge 100 ]]; then
                    ((dial -= 100))
                fi

                if [[ dial -eq 0 ]]; then
                    ((passed++))
                fi

                            done
            ;;
    esac

    if [[ dial -eq 0 ]]; then
        ((password++))
    fi

done < $1

echo "The password for part one is: $password."

echo "The password for the part two is: $passed."
