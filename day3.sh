#!/bin/bash

sum_one=0
sum_two=0

while read bank; do
    max=0
    len=${#bank}
    keep=12
    result=""
    skip=$((len-keep))

    echo "$((++count))/$(wc -l $1 | awk '{print $1}')"
    for ((i=0; i<len; i++)); do
        left=${bank:i:1}

        for ((j=i+1; j<len; j++)); do
            right=${bank:j:1}
            num=${left}${right}

            if [[ num -gt max ]]; then
                max=$num
            fi
        done

        while [[ ${#result} -gt 0 ]] && [[ skip -gt 0 ]] && [[ ${result: -1} -lt left ]]; do
            result=${result%?}
            ((skip--))
        done

        if [[ ${#result} -lt keep ]]; then
            result=${result}${left}
        else
            ((skip--))
        fi
    done

    ((sum_one+=max))
    ((sum_two+=result))
done < $1

echo "The total joltage output for part one is: $sum_one."
echo "The total joltage output for part two is: $sum_two."
