#!/bin/bash

coords=()
while IFS=, read -r x y; do
    coords+=("$x,$y")
done < "$1"

max=0
for ((i=0; i<${#coords[@]}; i++)); do
    IFS=, read -r x1 y1 <<< "${coords[$i]}"
    
    for ((j=i+1; j<${#coords[@]}; j++)); do
        IFS=, read -r x2 y2 <<< "${coords[$j]}"
        
        width=$((x1 - x2 + 1))
        height=$((y1 - y2 + 1))
        area=$((width * height))
        
        if [[ area -gt max ]]; then
            max=$area
        fi
    done
done

echo "[part one] The largest area is: $max."
