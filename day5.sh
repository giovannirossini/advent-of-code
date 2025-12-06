#!/bin/bash

ranges=()
ids=()

while read line; do
    if [[ "$line" == *"-"* ]]; then
        ranges+=("$line")
    elif [[ ! -z "$line" ]]; then
        ids+=("$line")
    fi
done < $1

function part-one() {
    local count=0
    local found=false
    local first=()
    local last=()

    uids=($(printf "%s\n" "${ids[@]}" | sort -nu))
    for id in ${uids[@]}; do
        for range in ${ranges[@]}; do
            first="${range%-*}"
            last="${range#*-}"
            if ((id >= first)) && ((id <= last)); then
                found=true
                if [[ found ]]; then
                    ((count++))
                fi
                break
            fi
        done
    done
    echo "[part one] $count available ingredients are fresh."
}

function part-two() {
    local ranges=($(printf "%s\n" "${ranges[@]}" | sort -t'-' -k1 -n))
    local count=0
    local current_start
    local current_end
    
    current_start="${ranges[0]%-*}"
    current_end="${ranges[0]#*-}"
        
    for ((i=1; i<${#ranges[@]}; i++)); do
        local start="${ranges[$i]%-*}"
        local end="${ranges[$i]#*-}"

        
        if [[ $start -le $((current_end + 1)) ]]; then
            if [[ $end -gt $current_end ]]; then
                current_end=$end
            fi
        else
            ((count += current_end - current_start + 1))
            current_start=$start
            current_end=$end
        fi
    done
        
    ((count+=current_end - current_start + 1))
    
    echo "[part two] $count ingredient IDs are considered fresh."
}

part-one
part-two
