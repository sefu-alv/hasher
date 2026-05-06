#!/bin/bash

echo ""

while getopts "hH:w:" opt; do
	case $opt in
		h) echo "usage ./crack.sh -H <hash>"; exit 0 ;;
		H) hash=$OPTARG;;
		w) wordoption=$OPTARG;;
	esac
done

			
modes=($(hashid -m $hash | grep -oP '(?<=Hashcat Mode: )\d+'))


for mode in "${modes[@]}"; do
	echo "Trying mode: $mode"

	hashcat -m "$mode" $hash /usr/share/wordlists/$wordoption
done

