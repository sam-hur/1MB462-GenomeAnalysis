#!/bin/bash -l

#SBATCH -A uppmax2024-2-7 
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 2
#SBATCH -t 00:30:00
#SBATCH -J QC_DNA_PRETRIM
#SBATCH --mail-type=ALL
#SBATCH --mail-user sam.hurenkamp.9631@student.uu.se


#modules
module load bioinfo-tools
module load FastQC
module load MultiQC


base_dir=/home/samhur/1MB462-GenomeAnalysis/data
in=$base_dir/raw_data/genomics_data
out=$base_dir/metadata/QC/genomics_data

fastqc -o $out/Illumina -t 2 $in/Illumina/*.gz 
fastqc -o $out/Nanopore $in/Nanopore/*.gz
fastqc -o $out/PacBio -t 6 $in/PacBio/*.gz
