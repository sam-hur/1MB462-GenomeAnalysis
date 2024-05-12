#!/bin/bash -l

#SBATCH -A uppmax2024-2-7 
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 2
#SBATCH -t 00:30:00
#SBATCH -J QC_PRETRIM
#SBATCH --mail-type=ALL
#SBATCH --mail-user sam.hurenkamp.9631@student.uu.se


#modules
module load bioinfo-tools
module load FastQC


base_dir=/home/samhur/1MB462-GenomeAnalysis/data
in=$base_dir/raw_data/genomics_data
out=$base_dir/metadata/QC/genomics_data

mkdir -p \
    $out/Illumina \
    $out/NanoPore \
    $out/PacBio \
    $out/RNA-Seq_BHI \
    $out/RNA-Seq_Serum \
    $out/TN-Seq/BHI \
    $out/TN-Seq/Serum \
    $out/TN-Seq/HSerum

mkdir -p $out/Illumina/QC_PreTrim
fastqc -o $out/Illumina/QC_PreTrim -t 2 $in/Illumina/*.gz 
fastqc -o $out/Nanopore $in/Nanopore/*.gz
fastqc -o $out/PacBio -t 2 $in/PacBio/*.gz

# RNA
fastqc -o $out/RNA-Seq_BHI -t 2 $base_dir/raw_data/transcriptomics_data/RNA-Seq_BH/*.gz
fastqc -o $out/RNA-Seq_Serum -t 2 $base_dir/raw_data/transcriptomics_data/RNA-Seq_Serum/*.gz

# TN
fastqc -o $out/TN-Seq/BHI -t 2 $base_dir/raw_data/transcriptomics_data/Tn-Seq_BHI/*.gz
fastqc -o $out/TN-Seq/Serum -t 2 $base_dir/raw_data/transcriptomics_data/Tn-Seq_Serum/*.gz
fastqc -o $out/TN-Seq/HSerum -t 2 $base_dir/raw_data/transcriptomics_data/Tn-Seq_HSerum/*.gz



