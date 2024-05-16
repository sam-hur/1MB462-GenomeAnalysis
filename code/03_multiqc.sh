#!/bin/bash -l

#SBATCH -A uppmax2024-2-7 
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 2
#SBATCH -t 00:30:00
#SBATCH -J AGG_QC
#SBATCH --mail-type=ALL
#SBATCH --mail-user sam.hurenkamp.9631@student.uu.se

source ../config.cfg

#modules
module load bioinfo-tools
module load MultiQC

in=$out/FastQC/Illumina
out=$base_dir/output/Aggr/Illumina

mkdir -p $out

#aggregate QC reports
multiqc $in -o $out -p -v -f # > $out/Aggr/output.txt
