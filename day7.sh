#!/bin/bash

beam="|"
function splits() {
    local line="$1"
    local last_line="$2"
    local len=${#line}
    local new_line=""
    local splitters=0

    for ((i=0; i<len; i++)); do
        if [[ "${line:i:1}" == "." ]] && [[ "${line:i+1:1}" == "^" ]]; then
            new_line+=${beam}
        elif [[ "${line:i:1}" == "." ]] && [[ "${line:i-1:1}" == "^" ]]; then
            new_line+=${beam}
        elif [[ "${line:i:1}" == "." ]] && [[ "${last_line:i:1}" == "$beam" ]]; then
            new_line+=${beam}
        elif [[ "${line:i:1}" ==  "^" ]]; then
            new_line+="^"
            if [[ "${last_line:i:1}" == "$beam" ]]; then
                ((splitters++))
            fi
        else
            new_line+="."
        fi
    done
    echo "$new_line $splitters"
}

function timelines() {
    local -A paths
    local timelines=0
    
    paths["1,${1}"]=1
    
    for ((i=1; i<${#grid[@]}; i++)); do
        local line="${grid[$i]}"
        local -A next
        
        for k in "${!paths[@]}"; do
            IFS="," read -r r c <<< "$k"
            
            if [[ r -ne i ]]; then
                continue
            fi
            
            count=${paths[$k]}
            next_line=$((r+1))
            
            if [[ "${line:c:1}" == "^" ]]; then
                left=$((c-1))
                right=$((c+1))
                
                if [[ left -ge 0 ]]; then
                    lk="${next_line},${left}"
                    next[$lk]=$((${next[$lk]:-0}+count))
                fi
                
                if [[ right -lt ${#line} ]]; then
                    rk="${next_line},${right}"
                    next[$rk]=$((${next[$rk]:-0}+count))
                fi
            else
                nk="${next_line},${c}"
                next[$nk]=$((${next[$nk]:-0}+count))
            fi
        done
        
        for k in "${!next[@]}"; do
            paths[$k]=${next[$k]}
        done
    done
    
    for k in "${!paths[@]}"; do
        IFS="," read -r r col <<< "$k"
        if [[ r -eq ${#grid[@]} ]]; then
            timelines=$((timelines+${paths[$k]}))
        fi
    done
    
    echo "$timelines"
}

grid=()

while read line; do
    grid+=("$line")
done < "$1"

first_line=${grid[0]}
start=$(($(wc -c <<< ${first_line%%"S"*})-1))

echo "      ${grid[0]}              ${grid[0]}"
line=${grid[1]}
new_line="${line:0:start}${beam}${line:start+1}"
echo "      $line              ${new_line}"

for ((i=2; i<${#grid[@]}; i++)); do
    line=${grid[$i]}
    echo -ne "      $line"
    if [[ "$line" =~ \^ ]]; then
        result=$(splits "$line" "$new_line")
        new_line=$(awk '{print $1}' <<< "$result")
        times=$(awk '{print $2}' <<< "$result")
        ((splitters+=times))
    else
        new_line=${new_line//\^/.}
    fi

    echo "              $new_line"
done

echo -e "\n[part one] The beam will split $splitters times."
echo -e "[part two] The total different timeline a beam would end up is: $(timelines $start)."
