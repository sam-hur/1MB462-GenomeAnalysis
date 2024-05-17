#!/bin/bash -l

#SBATCH -A uppmax2024-2-7 
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 2
#SBATCH -t 00:10:00
#SBATCH -J QC_BWA
#SBATCH --mail-type=ALL
#SBATCH --mail-user sam.hurenkamp.9631@student.uu.se

source ../config.cfg
module load \
    bioinfo-tools \
    samtools

mapped=$out/mapping/bwa2/*.bam
mkdir $out/mapping/bwa2/QC
for f in $mapped; do
    bn=$(basename "$f" | grep -oE 'ERR[0-9]+')
    samtools flagstat $f > $out/mapping/bwa2/QC/"${bn}_qc.out"
done
