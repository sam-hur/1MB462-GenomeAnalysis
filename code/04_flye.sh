#!/bin/bash -l

#SBATCH -A uppmax2024-2-7 
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 2
#SBATCH -t 02:30:00
#SBATCH -J Assembly_FLYE
#SBATCH --mail-type=ALL
#SBATCH --mail-user sam.hurenkamp.9631@student.uu.se


t=2  #thread_count

#modules
module load \
	bioinfo-tools \
	Flye \

base_dir=/home/samhur/1MB462-GenomeAnalysis/data
in=$base_dir/raw_data/genomics_data
out=$base_dir/metadata/QC/genomics_data/assemblies/flye

mkdir -p $out/pb
mkdir $out/np


set -euo pipefail

# Assembly of pacbio + nanopore (maybe)?
set -x

flye --threads $t --pacbio-raw $in/PacBio/* --out-dir $out/pb # individual pb
flye --threads $t --nano-raw $in/Nanopore/* --out-dir $out/np # individual np

#Combined hybrid assembly
flye --threads $t --pacbio-raw $in/PacBio/* --nano-raw $in/Nanopore/* --out-dir $out  # PB+NP


set +x

