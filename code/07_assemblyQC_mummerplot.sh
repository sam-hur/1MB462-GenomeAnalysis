#!/bin/bash -l

#SBATCH -A uppmax2024-2-7 
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 2
#SBATCH -t 03:30:00
#SBATCH -J Assembly_QC_MUMmer
#SBATCH --mail-type=ALL
#SBATCH --mail-user sam.hurenkamp.9631@student.uu.se


t=2

source ../config.cfg
#modules
module load \
	bioinfo-tools \
	MUMmer/4.0.0rc1 \

mkdir -p $out/assemblies_QC/MUMmer
assembly=$out/assemblies/flye/pb/assembly.fasta
assembly2=$out/assemblies/spades/contigs.fasta

ref=/home/samhur/1MB462-GenomeAnalysis/ref_genome
ref1=$ref/GCF_009734005.1/ref_NCBI.fna
ref2=$ref/GCA_009734005.2/ref_GenBank.fna # just optional alt.

# ------------------------
out=$out/assemblies_QC/MUMmer

# nucmer --maxmatch -c 100 -p $out/nucmer $ref1 $assembly 
nucmer -p $out/nucmer.flye $ref1 $assembly
delta-filter -1 $out/nucmer.flye.delta > $out/filtered_alignments.flye.delta
mummerplot --png -p mummerplot.flye $out/filtered_alignments.flye.delta 
mv mummerplot.* $out

nucmer -p $out/nucmer.spades $ref1 $assembly2
delta-filter -1 $out/nucmer.spades.delta > $out/filtered_alignments.spades.delta
mummerplot --png -p mummerplot.spades $out/filtered_alignments.spades.delta 
mv mummerplot.* $out

