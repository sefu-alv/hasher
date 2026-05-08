#!/bin/bash

echo ""

while getopts "hH:w:" opt; do
	case $opt in
		h) echo "usage $0 -H <hash> -w <wordlist>"; 
			exit 0 ;;
		H)
		       	hash=$OPTARG;;
		w) 
			wordoption=$OPTARG;;
		*) echo "usage $0 -H <hash> -w <wordlist>"
			exit 1;;
	esac
done

if [[ -z "$hash" || -z "$wordoption" ]]; then
    echo "usage $0 -H <hash> -w <wordlist>"
    exit 1
fi
		

modes=($(hashid -m $hash | grep -oP '(?<=Hashcat Mode: )\d+'))


for mode in "${modes[@]}"; do
    echo "Trying mode: $mode"
    result=$(hashcat -D 1 --force -m "$mode" --quiet "$hash" /usr/share/wordlists/$wordoption 2>&1)
    if echo "$result" | grep -q "Separator unmatched\|No hashes loaded"; then
        echo "Skipping mode $mode (incompatible format)"
        continue
    fi

    # Check potfile whether it was just cracked or cracked previously
    cracked=$(hashcat --show -m "$mode" "$hash" 2>/dev/null | grep -oP '(?<=:).+$')
    if [[ -n "$cracked" ]]; then
        echo "Cracked! Plaintext: $cracked"
        exit 0
    fi
done
