#!/bin/bash -l

#SBATCH -A uppmax2024-2-7 
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 2
#SBATCH -t 03:30:00
#SBATCH -J Annotation_Prokka
#SBATCH --mail-type=ALL
#SBATCH --mail-user sam.hurenkamp.9631@student.uu.se


t=2

#modules
module load \
	bioinfo-tools \
	prokka/1.45-5b58020 \


base_dir=/home/samhur/1MB462-GenomeAnalysis/data
in=$base_dir/raw_data/genomics_data
out=$base_dir/metadata/QC/genomics_data


mkdir -p $out/annotations/Prokka
assembly=$out/assemblies/flye/pb/assembly.fasta
assembly2=$out/assemblies/spades/contigs.fasta
ref=/home/samhur/1MB462-GenomeAnalysis/ref_genome
ref1=$ref/GCF_009734005.1/ref_NCBI.fna
ref2=$ref/GCA_009734005.2/ref_GenBank.fna # just optional alt.


set -x
# ------------------------
prefix1=prokka.flye
prefix2=prokka.spades
out=$out/annotations/Prokka
mkdir $out/spades $out/flye

# Flye assembly
prokka --force --outdir $out/flye --prefix $prefix1 \
    --usegenus --genus Enterococcus --species faecium \
    --kingdom Bacteria --gram pos --strain E745 \
    $assembly

# Spades assembly
prokka --force --outdir $out/spades --prefix $prefix2 \
    --usegenus --genus Enterococcus --species faecium \
    --kingdom Bacteria --gram pos --strain E745 \
    $assembly2

# ------------------------
set +x

