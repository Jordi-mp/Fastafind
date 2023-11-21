#!/bin/bash 

# 1. the folder X where to search files (default: current folder) 
Folder="${1}"  
# 2. a number of lines N (default: 0)
Lines="${2:-0}"  # ":-" is used as a default value operator 

# Find fasta/fa files 
F=$(find "$Folder" -type f -name "*.fa" -o -name "*.fasta")

# Count the number of fasta/fa files 
echo "Number of fasta/fa files is: $(echo "$F" | wc -l)" 

# Count the number of unique fasta IDs 
echo "Number of unique fasta IDs: $(grep -o "^>" $F | sort -u | wc -l)" # grep -o only prints matching lines and we use "^>" to match a greater-than symbol (>) 
                                                                        # only if it appears at the beginning of a line (^)."

echo " "
echo Report of the files:
echo "........................................................................."
echo " "
