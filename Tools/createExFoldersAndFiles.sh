#!/bin/bash
# This script creates a series of folders and files for Pool project.
# Usage: ./createFiles.sh
# Check if the script is being run from the correct directory where you want to create the ex{00..N} folders and files.

path=$(pwd)/../13
fullpath="$path/ex0"

strings=(
    people.ml
    doctor.ml
	dalek.ml
	army.ml
	galifrey.ml
)
index=0

for i in "${strings[@]}"; do
	# if [ -f "$fullpath/$i" ]; then
	# 	echo "File $fullpath/$i already exists. Skipping."
	# 	((index++))
	# 	continue
	# fi
	mkdir -p "$fullpath$index"
	for j in "${strings[@]}"; do
		touch "$fullpath$index/$j"
		touch "$fullpath$index/main.ml"
		echo "File $fullpath$index/$j created."
		if [ "$j" == "$i" ]; then
			break
		fi
	done;
	# touch "$fullpath$index/$i"
	# touch "$fullpath$index/main.ml"
	# if [ "$i" == "Deck.ml" ]; then
	# 	touch "$fullpath$index/Deck.mli"
	# fi
	echo "File $fullpath$index/$i created."
	((index++))

	# Uncomment the following lines to add a module structure to the file
	# echo "module $i = struct" >> "$fullpath$index/$i"
	# echo "  (* Your code here *)" >> "$fullpath$index/$i"
	# echo "end" >> "$fullpath$index/$i"
	# echo "" >> "$fullpath$index/$i"
done
