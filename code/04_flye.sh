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


source ../config.cfg
#modules
module load \
	bioinfo-tools \
	Flye \

in=$base_dir/raw_data/genomics_data
out=$out/assemblies/flye

mkdir -p $out/pb
mkdir $out/np

flye --threads $t --pacbio-raw $in/PacBio/* --out-dir $out/pb # individual pb
flye --threads $t --nano-raw $in/Nanopore/* --out-dir $out/np # individual np

#Combined hybrid assembly
flye --threads $t --pacbio-raw $in/PacBio/* --nano-raw $in/Nanopore/* --out-dir $out  # PB+NP


