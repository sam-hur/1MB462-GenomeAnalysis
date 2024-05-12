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
module load bioinfo-tools \
	FastQC \
	trimmomatic \


#---
# environment config
#---
printf "\n\n\n"
cat $0
echo USER = $USER
echo QOS = $SLURM_JOB_QOS
echo DATETIME: $(date +"%Y-%m-%d %H:%M:%S.%3N")


# #---
# set -x
# #---

base_dir=/home/samhur/1MB462-GenomeAnalysis/data
in=$base_dir/raw_data/genomics_data
out=$base_dir/metadata/QC/genomics_data

# Illumina
#source:https://www.biostars.org/p/366041/
illumina_base=$in/Illumina
Il1=$illumina_base/"E745-1.L500_SZAXPI015146-56_1_clean.fq.gz"
Il2=$illumina_base/"E745-1.L500_SZAXPI015146-56_2_clean.fq.gz"

mkdir -p $out/trimmed_data

P1="$out/trimmed_data/Illumina_trimmed_1P.fq"
U1="$out/trimmed_data/Illumina_trimmed_1U.fq"
P2="$out/trimmed_data/Illumina_trimmed_2P.fq"
U2="$out/trimmed_data/Illumina_trimmed_2U.fq"

java -jar $TRIMMOMATIC_ROOT/trimmomatic.jar \
PE -threads 2 -phred64 $Il1 $Il2 $P1 $U1 $P2 $U2 \
ILLUMINACLIP:"$TRIMMOMATIC_HOME/adapters/TruSeq3-PE.fa":2:30:10 \
LEADING:3 SLIDINGWINDOW:5:20 MINLEN:36 \
> $out/trimmed_data/log.out

# #---
# set x+
# #---


