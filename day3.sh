#!/bin/bash

sum=0

while read bank; do
    max=0
    len=${#bank}

    echo "$((++count))/$(wc -l $1 | awk '{print $1}')"
    for ((i=0; i<len-1; i++)); do
        left=${bank:i:1}

        for ((j=i+1; j<len; j++)); do
            right=${bank:j:1}
            num=${left}${right}

            if [[ num -gt max ]]; then
                max=$num
            fi
        done
    done

    ((sum+=max))
done < $1

echo "The total joltage output is: $sum."
