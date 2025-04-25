#!/bin/bash
# This script creates a series of folders and files for Pool project.
# Usage: ./createFiles.sh
# Check if the script is being run from the correct directory where you want to create the ex{00..N} folders and files.

strings=(
    encode.ml
    crossover.ml
	gray.ml
	sequence.ml
	nucleotides.ml
	helix.ml
	rna.ml
	ribosome.ml
	life.ml
)
index=0

for i in "${strings[@]}"; do
	if [ -f "ex0$index/$i" ]; then
		echo "File ex0$index/$i already exists. Skipping."
		((index++))
		continue
	fi
	mkdir -p "ex0$index"
	touch "ex0$index/$i"
	echo "File ex0$index/$i created."
	((index++))

	# Uncomment the following lines to add a module structure to the file
	# echo "module $i = struct" >> "$i"
	# echo "  (* Your code here *)" >> "$i"
	# echo "end" >> "$i"
	# echo "" >> "$i"
done
