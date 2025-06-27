#!/bin/bash

# 1 line 1 sequence
# Merge all lines into a single line and separate by "@"
# Place new line before every ">"
#tr "\n" "@" < 100226.110.fna | sed 's/>/\n>/g' | grep -v "^$" | head -n 1 > temp.txt # Example input

# Delete "@" and write to DNAseq.txt
cut -d "@" -f 2- < temp.txt | tr -d "@" > direct.txt

# Make complement strand
cat direct.txt | tr 'atcg' 'tagc' > complement.txt

cat complement.txt | rev > reverse.txt

rm temp.txt complement.txt # Remove to keep clean environment; we are working with direct.txt and reverse.txt


# F+1
echo ">F+1" > orfF1.txt
sed -r 's/.{3}/& /g' direct.txt >> orfF1.txt
# F+2
echo -e "\n>F+2" > orfF2.txt
cut -c 2- direct.txt | sed -r 's/.{3}/& /g' >> orfF2.txt
# F+3
echo -e "\n>F+3" > orfF3.txt
cut -c 3- direct.txt | sed -r 's/.{3}/& /g' >> orfF3.txt

# F-1
echo -e "\n>F-1" > orfR1.txt
sed -r 's/.{3}/& /g' reverse.txt >> orfR1.txt
# F-2
echo -e "\n>F-2" > orfR2.txt
cut -c 2- reverse.txt | sed -r 's/.{3}/& /g' >> orfR2.txt
# F-3
echo -e "\n>F-3" > orfR3.txt
cut -c 3- reverse.txt | sed -r 's/.{3}/& /g' >> orfR3.txt

rm direct.txt reverse.txt # Remove to clean


# New line for stop codon
# Mark atg with *
# Remove everything up to first * (* is included in removal)
sed -r 's/tga|taa|tag/&\n/g' orfF1.txt | sed -r 's/atg/*&/g' | sed -r 's/[^*]*\*//' > taggedF1.txt
sed -r 's/tga|taa|tag/&\n/g' orfF2.txt | sed -r 's/atg/*&/g' | sed -r 's/[^*]*\*//' > taggedF2.txt
sed -r 's/tga|taa|tag/&\n/g' orfF3.txt | sed -r 's/atg/*&/g' | sed -r 's/[^*]*\*//' > taggedF3.txt
sed -r 's/tga|taa|tag/&\n/g' orfR1.txt | sed -r 's/atg/*&/g' | sed -r 's/[^*]*\*//' > taggedR1.txt
sed -r 's/tga|taa|tag/&\n/g' orfR2.txt | sed -r 's/atg/*&/g' | sed -r 's/[^*]*\*//' > taggedR2.txt
sed -r 's/tga|taa|tag/&\n/g' orfR3.txt | sed -r 's/atg/*&/g' | sed -r 's/[^*]*\*//' > taggedR3.txt

# But some of these lines will not have atg at all

# Filter for orfs that begin with atg
# Here we keep lines that begin with atg (account for potential spaces in front)
# awk allows for numbering of each line
grep -E '^ *atg' taggedF1.txt | awk '{print ">ORF_F+1: " NR "\n", $0}' > tagged_filterF1.txt
grep -E '^ *atg' taggedF2.txt | awk '{print ">ORF_F+2: " NR "\n", $0}' > tagged_filterF2.txt
grep -E '^ *atg' taggedF3.txt | awk '{print ">ORF_F+3: " NR "\n", $0}' > tagged_filterF3.txt
grep -E '^ *atg' taggedR1.txt | awk '{print ">ORF_F-1: " NR "\n", $0}' > tagged_filterR1.txt
grep -E '^ *atg' taggedR2.txt | awk '{print ">ORF_F-2: " NR "\n", $0}' > tagged_filterR2.txt
grep -E '^ *atg' taggedR3.txt | awk '{print ">ORF_F-3: " NR "\n", $0}' > tagged_filterR3.txt

# Remove to clean
rm orfF1.txt orfF2.txt orfF3.txt orfR1.txt orfR2.txt orfR3.txt taggedF1.txt taggedF2.txt taggedF3.txt taggedR1.txt taggedR2.txt taggedR3.txt 

# Combine all to one file
cat tagged_filterF1.txt tagged_filterF2.txt tagged_filterF3.txt tagged_filterR1.txt tagged_filterR2.txt tagged_filterR3.txt > tagged_filter.txt

# Remove to clean
rm tagged_filterF1.txt tagged_filterF2.txt tagged_filterF3.txt tagged_filterR1.txt tagged_filterR2.txt tagged_filterR3.txt


# Remove * from tagged atg
sed 's/*//g' tagged_filter.txt > good.txt
rm tagged_filter.txt

# Translate codons to AA
# Remove spaces with tr -d ' '
# Stop codons are marked with *
sed -r 's/atg/M/g' good.txt | sed -r 's/gct|gcc|gca|gcg/A/g' | sed -r 's/tgt|tgc/C/g' | sed -r 's/gat|gac/D/g' | sed -r 's/gaa|gag/E/g' | sed -r 's/ttt|ttc/F/g' | sed -r 's/ggt|ggc|gga|ggg/G/g' | sed -r 's/cat|cac/H/g' | sed -r 's/att|atc|ata/I/g' | sed -r 's/aaa|aag/K/g' | sed -r 's/tta|ttg|ctt|ctc|cta|ctg/L/g' | sed -r 's/aat|aac/N/g' | sed -r 's/cct|ccc|cca|ccg/P/g' | sed -r 's/caa|cag/Q/g' | sed -r 's/cgt|cgc|cga|cgg|aga|agg/R/g' | sed -r 's/tct|tcc|tca|tcg|agt|agc/S/g' | sed -r 's/act|acc|aca|acg/T/g' | sed -r 's/gtt|gtc|gta|gtg/V/g' | sed -r 's/tgg/W/g' | sed -r 's/tat|tac/Y/g' | sed -r 's/taa|tag|tga/*/g' | tr -d ' ' > ORF_BL.faa

# We should have translated sequences (only keeping those that start with M) -> .faa is good


# Let's remove spaces in .fna
# Replace newline characters with @
# Remove all spaces
# Replace @ with newline characters
tr "\n" "@" < good.txt | tr -d " " | tr "@" "\n" > ORF_BL.fna

rm good.txt # Clean
