#!/bin/bash

input="$1"
pairs="$2"

declare -a boxes
while read -r line; do
    boxes+=("$line")
done < "$input"

echo "Read ${#boxes[@]} junction boxes"

declare -a distances
for ((i=0; i < ${#boxes[@]}; i++)); do
    IFS=, read -r x1 y1 z1 <<< "${boxes[$i]}"
    
    for ((j=i+1; j < ${#boxes[@]}; j++)); do
        IFS=, read -r x2 y2 z2 <<< "${boxes[$j]}"
        
        dx=$((x1 - x2))
        dy=$((y1 - y2))
        dz=$((z1 - z2))
        sqrd=$((dx*dx + dy*dy + dz*dz))
        distances+=("$sqrd|$i|$j")
    done
done

sorted_distances=($(printf "%s\n" "${distances[@]}" | sort -n -t'|' -k1))

declare -a parent
for ((i=0; i < ${#boxes[@]}; i++)); do
    parent[$i]=$i
done

find_parent() {
    local node=$1
    if [[ ${parent[$node]} -ne $node ]]; then
        parent[$node]=$(find_parent ${parent[$node]})
    fi
    echo ${parent[$node]}
}

union() {
    local node1=$1
    local node2=$2
    
    local root1=$(find_parent $node1)
    local root2=$(find_parent $node2)
    
    if [[ $root1 -ne $root2 ]]; then
        parent[$root2]=$root1
        return 0  
    else
        return 1
    fi
}

connections=0
for ((i=0; i < pairs && i < ${#sorted_distances[@]}; i++)); do
    IFS='|' read -r d b1 b2 <<< "${sorted_distances[$i]}"
    
    if union "$b1" "$b2"; then
        ((connections++))
    fi
done

echo "Processed $pairs pairs, made $connections actual connections"

declare -A circuit
for ((i=0; i < ${#boxes[@]}; i++)); do
    root=$(find_parent $i)
    ((circuit[$root]++))
done

declare -a sizes
for root in "${!circuit[@]}"; do
    size=${circuit[$root]}
    sizes+=($size)
done

sorted_sizes=($(printf "%s\n" "${sizes[@]}" | sort -rnu))

echo "Circuit sizes (sorted): ${sorted_sizes[@]}"

result=1
for ((i=0; i < 3 && i < ${#sorted_sizes[@]}; i++)); do
    result=$((result * ${sorted_sizes[$i]}))
done

echo ""
echo "[part one] The product of the three largest circuit sizes: $result"
