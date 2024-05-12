#!/bin/bash -l

#SBATCH -A uppmax2024-2-7 
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 1
#SBATCH -t 36:00:00
#SBATCH -J GA_MAIN
#SBATCH --mail-type=ALL
#SBATCH --mail-user sam.hurenkamp.9631@student.uu.se

jobs=$(ls ~/1MB462-GenomeAnalysis/code/*_*.sh)
echo $jobs
for f in $jobs; do
    sbatch -W $f
done;
wait