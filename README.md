# open-reading-frame-finder

This open reading frame (ORF) finder program was part of my project submitted for **</ind>BIOL 474/574 - Bioinformatics<ind>** at California State University, Long Beach with Dr. Renaud Berlemont in Spring 2025.
After assembling sequenced DNA reads into contigs, the ORF finder identifies potential genes (regions that may undergo transcription) from all possible reading frames.

This is a part of a larger workflow as described below:
1. Sequenced DNA reads of an unknown bacterium are given.
2. DNA assembly is performed with BV-BRC.
3. ORF finder identifies potential genes.
4. BLAST with 16S rRNA to identify organism.
5. BLAST ORF to match against known proteins.
6. Randomly select a found protein for BLAST, select related proteins, and perform multiple sequence alignment with Clustal Omega.
7. Use Newick tools to create phylogenetic trees and study relations between proteins.
