#!/bin/bash -l

#SBATCH -A uppmax2024-2-7 
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 2
#SBATCH -t 01:30:00
#SBATCH -J TRIMMOMATIC_Illumina
#SBATCH --mail-type=ALL
#SBATCH --mail-user sam.hurenkamp.9631@student.uu.se


#modules
module load bioinfo-tools
module load FastQC
module load MultiQC
module load trimmomatic

base_dir=/home/samhur/1MB462-GenomeAnalysis/data
in=$base_dir/raw_data/genomics_data
out=$base_dir/metadata/QC/genomics_data

#Illumina
#source:https://www.biostars.org/p/366041/
illumina_base=$in/Illumina/E745-1.L500_SZAXPI015146-56_1_clean.fq.gz

java -jar $TRIMMOMATIC_ROOT/trimmomatic.jar \
PE -threads 2 -phred64 \
-trimlog ./logs/trimmomatic_logs.txt \
-basein $illumina_base \
-baseout $base_dir/trimmed_data/Illumina_1_trimmed.fq.gz \
ILLUMINACLIP:$TRIMMOMATIC_HOME/adapters/TruSeq3-SE.fa:2:30:10 \
SLIDINGWINDOW:5:20:10 \

 
