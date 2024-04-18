#!/bin/bash -l

#SBATCH -A uppmax2024-2-7 
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 2
#SBATCH -t 18:00:00
#SBATCH -J Annotation_eggNOG-mapper
#SBATCH --mail-type=ALL
#SBATCH --mail-user sam.hurenkamp.9631@student.uu.se


t=2

#modules
module load \
	bioinfo-tools \
	eggNOG-mapper/2.1.9 \

base_dir=/home/samhur/1MB462-GenomeAnalysis/data
in=$base_dir/raw_data/genomics_data
out=$base_dir/metadata/QC/genomics_data


mkdir -p $out/annotations/eggNOG-mapper
assembly=$out/assemblies/flye/pb/assembly.fasta
assembly2=$out/assemblies/spades/contigs.fasta
ref=/home/samhur/1MB462-GenomeAnalysis/ref_genome
ref1=$ref/GCF_009734005.1/ref_NCBI.fna
ref2=$ref/GCA_009734005.2/ref_GenBank.fna # just optional alt.


set -x
# ------------------------
prefix1=eggNOG.flye
prefix2=eggNOG.spades
out=$out/annotations/eggNOG-mapper
mkdir $out/spades $out/flye

# Flye assembly
emapper.py \
    -i $assembly \
    --override \
    --itype genome \
    -o $prefix1
    --output_dir $out \

# ------------------------
set +x

