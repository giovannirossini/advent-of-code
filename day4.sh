#!/bin/bash

grid=()
accessible=0
directions=("-1 -1" "-1 0" "-1 1" "0 -1" "0 1" "1 -1" "1 0" "1 1")
reset="true"

while read line; do
    grid+=("$line")
done < "$1"

rows=${#grid[@]}
cols=${#grid[0]}

while [[ "$reset" == "true" ]]; do
	reset="false"

	for ((i=0; i<rows; i++)); do
	    for ((j=0; j<cols; j++)); do
	        char=${grid[$i]:$j:1}
	        
	        count=0
	        if [[ "$char" == "@" ]]; then
	            for direction in "${directions[@]}"; do
	                read dir_row dir_col <<< "$direction"
	                next_row=$((i + dir_row))
	                next_col=$((j + dir_col))
	        
	                if [[ next_row -ge 0 ]] && [[ next_row -lt rows ]] && [[ next_col -ge 0 ]] && [[ next_col -lt cols ]]; then
	                    char=${grid[$next_row]:$next_col:1}
	                    if [[ "$char" == "@" ]]; then
	                        ((count++))
	                    fi
	                fi
	            done
	            
	            if [[ count -lt 4 ]]; then
	                ((accessible++))
	                grid[$i]="${grid[$i]:0:$j}.${grid[$i]:$((j+1))}"
	                reset="true"
	            fi
	        fi
	    done
	done
done

echo "The number of accessible rolls of paper is: $accessible."

# debug
# for ((i=0;i<rows; i++)); do
#     echo ${grid[$i]}
# done
