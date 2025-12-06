#!/bin/bash

input=$1
columns=$(head -n1 $input | wc -w)
sum=0

for ((i=1;i<=$columns; i++)); do
    set -f
    column=($(awk -v idx="$i" '{print $idx}' "$input"))
    last=$((${#column[@]}-1))
    operation=${column[$last]}
    unset column[$last]
    math=$(printf " %s ${operation}" "${column[@]}" | awk '{$NF=""; print}')
    sum=$((sum+math))
    set +f
done

echo -e "[part one] The total grand is: $sum"
