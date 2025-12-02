#!/bin/bash

input=($(tr ',' '\n' < $1))

sum_invalids=0

for id in ${input[@]}; do
    first_id="${id%-*}"
    last_id="${id#*-}"

    for ((i=first_id; i<=last_id; i++)) do
        len=${#i}
        if ((len % 2 == 0)); then
            half=$((len/2))
            if [[ ${i:0:half} == ${i:half:len} ]]; then
                ((sum_invalids += i))
            fi
        fi
    done
done

echo "Total invalids are: $sum_invalids."
