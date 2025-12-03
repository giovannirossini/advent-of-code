#!/bin/bash

input=($(tr ',' '\n' < $1))

part_one=0
part_two=0
count=0

for id in ${input[@]}; do
    first="${id%-*}"
    last="${id#*-}"

    echo "$((++count))/${#input[@]}"

    for ((num=first; num<=last; num++)) do
        len=${#num}
        mid=$((len / 2))
        
        if ((len % 2 == 0)); then
            half=$((len/2))
            if [[ ${num:0:half} == ${num:half:len} ]]; then
                ((part_one += num))
            fi
        fi

        for ((i=1; i<=mid; i++)); do
            subsrt=${num:0:i}
            
            if ((len % i == 0)); then
                x=$((len / i))

                newstr=''
                for ((j=0; j<x; j++)); do
                    newstr+=$subsrt
                done

                if ((newstr == num)); then
                    ((part_two += num ))
                    continue 2
                fi
            fi
        done
    done
done

echo "The sum of invalids for part one is: $part_one."
echo "The sum of invalids for part two is: $part_two."
