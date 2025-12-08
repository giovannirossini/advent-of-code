#!/bin/bash

beam="|"
function pass() {
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
        result=$(pass "$line" "$new_line")
        new_line=$(awk '{print $1}' <<< "$result")
        sppliters=$((sppliters + $(awk '{print $2}' <<< "$result")))
    else
        new_line=${new_line//\^/.}
    fi
    echo "              $new_line"
done

echo -e "\n[part one] The beam will split $sppliters times."
