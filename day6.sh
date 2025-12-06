#!/bin/bash


input=$1
columns=$(head -n1 $input | wc -w)

function part-one() {
    set -f
    local sum
    for ((i=1;i<=$columns; i++)); do
        column=($(awk -v idx="$i" '{print $idx}' "$input"))
        last=$((${#column[@]}-1))
        operation=${column[$last]}
        unset column[$last]
        math=$(printf " %s ${operation}" "${column[@]}" | awk '{$NF=""; print}')
        sum=$((sum+math))
    done
    set +f
    echo -e "[part one] The total grand is: $sum"
}

function part-two() {
    set -f

    lines=()
    while IFS='' read -r line || [[ -n $line ]]; do
        lines+=("$line")
    done < "$input"

    max_len=0
    for line in "${lines[@]}"; do
        (( ${#line} > max_len )) && max_len=${#line}
    done

    total=0
    nums=()

    for ((col=0; col<=max_len; col++)); do
        vertical=""
        col_is_empty=1
        
        for ((r=0; r<${#lines[@]}; r++)); do
            char="${lines[$r]:$col:1}" 
            
            if [[ "$char" == "+" ]] || [[ "$char" == "*" ]]; then
                operation="$char"
                col_is_empty=0
            elif [[ "$char" =~ [0-9] ]]; then
                vertical="${vertical}${char}"
                col_is_empty=0
            fi
        done

        if [[ col_is_empty ]] && [[ -n "$vertical" ]]; then
             nums+=("$vertical")
        else
            if [[ ${#nums[@]} -gt 0 ]]; then
                result=${nums[0]}
                
                for ((i=1; i<${#nums[@]}; i++)); do
                        math="$result $operation ${nums[$i]}"
                        result=$((math))
                done
                
                total=$((total + result))
                nums=()
            fi
        fi
    done
    set +f
    echo "[part two] The total grand is: $total"
}

part-one
part-two
