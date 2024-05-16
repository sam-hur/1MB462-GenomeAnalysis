#!/bin/bash -l

#SBATCH -A uppmax2024-2-7 
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 1
#SBATCH -t 36:00:00
#SBATCH -J GA_MAIN_Test
#SBATCH --mail-type=ALL
#SBATCH --mail-user sam.hurenkamp.9631@student.uu.se

source ../config.cfg

jobs=$(ls ~/1MB462-GenomeAnalysis/code/*_*.sh)
IFS=$'\n' read -r -d '' -a jobs_array <<<"$jobs"


set -x
QC_pre_trim="${jobs_array[0]}"
trimmomatic="${jobs_array[1]}"
QC_post_trim="${jobs_array[2]}"
QC_Aggr_multiqc="${jobs_array[3]}"
Assembly_Flye="${jobs_array[4]}"
Assembly_SPAdes="${jobs_array[5]}"
Assembly_quast="${jobs_array[6]}"
Assembly_mummerplot="${jobs_array[7]}"
Annotation_prokka="${jobs_array[8]}"
Annotation_eggNOG="${jobs_array[9]}"
BWA="${jobs_array[10]}"
read_counts="${jobs_array[11]}"
busco="${jobs_array[12]}"
set +x

sbatch -W $QC_pre_trim
sbatch -W $trimmomatic
sbatch -W $QC_post_trim
sbatch $QC_Aggr_multiqc
sbatch $Assembly_Flye
sbatch $ass
