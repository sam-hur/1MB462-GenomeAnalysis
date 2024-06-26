#!/bin/bash -l

#SBATCH -A uppmax2024-2-7 
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 2
#SBATCH -t 00:30:00
#SBATCH -J QC_PRETRIM
#SBATCH --mail-type=ALL
#SBATCH --mail-user sam.hurenkamp.9631@student.uu.se

source ../config.cfg

#modules
module load \
    bioinfo-tools \
    FastQC


out=$out/FastQC/
mkdir -p \
    $out/Illumina/Pre_Trim \
    $out/NanoPore \
    $out/PacBio \
    $out/RNA-Seq_BHI \
    $out/RNA-Seq_Serum

fastqc -o $out/Illumina/Pre_Trim -t 2 $in/Illumina/*.gz 
fastqc -o $out/Nanopore $in/Nanopore/*.gz
fastqc -o $out/PacBio -t 2 $in/PacBio/*.gz

# RNA
fastqc -o $out/RNA-Seq_BHI -t 2 $base_dir/raw_data/transcriptomics_data/RNA-Seq_BH/*.gz
fastqc -o $out/RNA-Seq_Serum -t 2 $base_dir/raw_data/transcriptomics_data/RNA-Seq_Serum/*.gz

# # TN
# fastqc -o $out/TN-Seq/BHI -t 2 $base_dir/raw_data/transcriptomics_data/Tn-Seq_BHI/*.gz
# fastqc -o $out/TN-Seq/Serum -t 2 $base_dir/raw_data/transcriptomics_data/Tn-Seq_Serum/*.gz
# fastqc -o $out/TN-Seq/HSerum -t 2 $base_dir/raw_data/transcriptomics_data/Tn-Seq_HSerum/*.gz



