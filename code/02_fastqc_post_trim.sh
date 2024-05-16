#!/bin/bash -l

#SBATCH -A uppmax2024-2-7 
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 2
#SBATCH -t 00:30:00
#SBATCH -J QC_DNA_POSTTRIM
#SBATCH --mail-type=ALL
#SBATCH --mail-user sam.hurenkamp.9631@student.uu.se

source ../config.cfg

#modules
module load \
    bioinfo-tools \
    FastQC

in=$out/trimmed_data
out=$out/FastQC/Illumina/Post_Trim
mkdir -p $out 

fastqc -o $out -t 2 $in/*.fq
