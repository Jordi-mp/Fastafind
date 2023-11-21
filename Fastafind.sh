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

# Process each file 
for i in $F; do 

# Print a nice header including filename 
echo "Processing file: $i" 

# Determine if the file is nucleotide or amino acids based on content 
if grep -q "NP" "$i"; then echo "Type: Protein fasta" 
else echo "Type: Nucleotide fasta"
 fi 

# Number of sequences 
echo "Number of sequences: $(grep -c ">" "$i")" 

# Total sequence length (excluding gaps, spaces, newline characters) 
echo "Sequence length: $(sed -n '/>/! { s/-//g; s/[:space:]//g; s/\///g; p; }' "$i" | tr -d '\n' | wc -m)"

# Check if the file is a symlink
 if [[ -h "$i" ]]; 
then echo "Symlink: Yes"
else echo "Symlink: No" 
fi 
echo " "

# Display file content
echo "File content:"
 if [[ "$(wc -l < "$i")" -le $((2 * $Lines)) ]];
 then cat "$i" 
elif [[ "$(wc -l < "$i")" -eq 0 ]];
 then echo "It has 0 lines" 
else head -n "$Lines" "$i"
 echo "..." 
tail -n "$Lines" "$i" 
fi 
done
