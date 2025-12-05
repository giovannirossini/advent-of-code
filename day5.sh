#!/bin/bash

ranges=()
ids=()
fresh=()
count=0

while read line; do
    if [[ "$line" == *"-"* ]]; then
        ranges+=("$line")
    elif [[ ! -z "$line" ]]; then
        ids+=("$line")
    fi
done < $1

for id in ${ids[@]}; do
    for range in ${ranges[@]}; do
        first="${range%-*}"
        last="${range#*-}"
        if ((id >= first)) && ((id <= last)); then
            if [[ ! "${fresh[*]}" =~ "$id" ]]; then
                fresh+=("$id")
                ((count++))
            fi
        fi
    done
done

echo "$count available ingredients are fresh."
