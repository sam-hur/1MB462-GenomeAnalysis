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

#modules
module load \
	bioinfo-tools \
	MUMmer/4.0.0rc1 \


base_dir=/home/samhur/1MB462-GenomeAnalysis/data
in=$base_dir/raw_data/genomics_data
out=$base_dir/metadata/QC/genomics_data


mkdir -p $out/assemblies_QC/MUMmer
assembly=$out/assemblies/flye/pb/assembly.fasta
ref=/home/samhur/1MB462-GenomeAnalysis/ref_genome
ref1=$ref/GCF_009734005.1/ref_NCBI.fna
ref2=$ref/GCA_009734005.2/ref_GenBank.fna # just optional alt.


set -x
# ------------------------
out=$out/assemblies_QC/MUMmer

# nucmer --maxmatch -c 100 -p $out/nucmer $ref1 $assembly 
nucmer -p $out/nucmer $ref1 $assembly
delta-filter -1 $out/nucmer.delta > $out/filtered_alignments.delta
mummerplot --postscript -p mummerplot $out/filtered_alignments.delta 
mv mummerplot.* $out
# show output
tree $out

# ------------------------
set +x

