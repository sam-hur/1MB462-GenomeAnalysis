#!/bin/bash -l

#SBATCH -A uppmax2024-2-7 
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 2
#SBATCH -t 00:30:00
#SBATCH -J AGG_QC
#SBATCH --mail-type=ALL
#SBATCH --mail-user sam.hurenkamp.9631@student.uu.se


#modules
module load bioinfo-tools
module load MultiQC


base_dir=/home/samhur/1MB462-GenomeAnalysis/data
in=$base_dir/metadata/QC/genomics_data

#aggregate QC reports
multiqc $in -o $out/Aggr -p -v -f # > $out/Aggr/output.txt
