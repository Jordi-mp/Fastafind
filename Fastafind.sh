#!/bin/bash 

echo " "
echo MSc in Bioinformatics for Health Sciences
echo Introduction to Algorithmics
echo "Jordi Martín Pérez (u235858)"
echo Midterm assignment: Fastascan
echo " "
echo "........................................................................."
echo " "

# 1. the folder X where to search files (default: current folder) 
Folder="${1:-.}"  # ":-" is used as a default value operator 
# 2. a number of lines N (default: 0)
Lines="${2:-0}"  

# Find fasta/fa files 
F=$(find "$Folder" -type f -name "*.fa" -o -name "*.fasta")

# Count the number of fasta/fa files 
echo "Number of fasta/fa files is: $(echo "$F" | wc -l)" 

# Count the number of unique fasta IDs 
echo "Number of unique fasta IDs: $(grep -o "^>" $F | sort -u | wc -l)" 
# grep -o only prints matching lines and we use "^>" to match a greater-than symbol (>) only if it appears at the beginning of a line (^).
# sort -u is used to remove duplicate lines, as we want to count the number of UNIQUE fasta IDs.

echo " "
echo Report of the files:
echo "........................................................................."
echo " "

# Process each file 
for i in $F; do 

# Print a nice header including filename 
echo "Processing file: $i" 

# Determine if the file is nucleotide or amino acids based on content 
if grep -q "NP" "$i"
then echo "Type: Protein fasta" 
else echo "Type: Nucleotide fasta"
 fi 

# Number of sequences 
echo "Number of sequences: $(grep -c ">" "$i")" 

# Total sequence length (excluding gaps, spaces, newline characters) 
echo "Sequence length: $(sed -n '/>/! { s/-//g; s/[:space:]//g; s/\n///g; p; }' "$i" | wc -m)"  

# We can breakdown this command, as it might be the most difficult and it includes some functions whcih have not been explicitly explained in class:
# - (sed -n '/>/!): sed -n supresses automatic printing. When combined with '/>/!, the neagtion indicates not to print the headers of the sequences (starting with >).
# - (s/-//g; s/[:space:]//g; s/\///g; p;) : here we are using the structure of replacements in sed to exclude gaps(-), spaces ([:space:]) and new line characters (\n) from being counted.
# g is used to cause the cahnge in all occurrences and the final p is used to print the file applying the replacements.
# - (wc -m): we had already seen the word count command. However, we are used to applying the function -l for line counting, while -m in wc -m is used to indicate character count.
                                                                                                            

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
echo " "
echo " "
echo Report of $i finished.
echo " "
echo "........................................................................."
echo " "
fi 
done
echo " "
echo Report of all fasta files in $1 finished!
echo " "
