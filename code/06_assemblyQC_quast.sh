#!/bin/bash -l

#SBATCH -A uppmax2024-2-7 
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 2
#SBATCH -t 03:30:00
#SBATCH -J Assembly_QC_Quast
#SBATCH --mail-type=ALL
#SBATCH --mail-user sam.hurenkamp.9631@student.uu.se


t=2

#modules
module load \
	bioinfo-tools \
	quast \


base_dir=/home/samhur/1MB462-GenomeAnalysis/data
in=$base_dir/raw_data/genomics_data
out=$base_dir/metadata/QC/genomics_data


mkdir -p $out/assemblies_QC/quast
assembly=$out/assemblies/flye/pb/assembly.fasta



set -x
# ------------------------
out=$out/assemblies_QC/quast

# clean output dir
rm -r $out


# --glimmer may be better for (incomplete) bacterial genomes, alt. use --gene-finding.
quast.py --threads $t --glimmer $assembly -o $out


# show output

tree $out

# ------------------------
set +x

