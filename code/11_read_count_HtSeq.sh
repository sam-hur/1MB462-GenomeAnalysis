#!/bin/bash -l

#SBATCH -A uppmax2024-2-7 
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 8
#SBATCH -t 24:00:00
#SBATCH -J rc_htseq
#SBATCH --mail-type=ALL
#SBATCH --mail-user sam.hurenkamp.9631@student.uu.se

t=8

#modules
module load \
	bioinfo-tools \
	htseq \

base_dir=/home/samhur/1MB462-GenomeAnalysis/data
in=$base_dir/raw_data/genomics_data
out=$base_dir/metadata/QC/genomics_data

set -x
# ------------------------
output_dir=htseq2
# ------------------------

mkdir -p $out/read_counts/$output_dir
mkdir -p $out/read_counts_eggNOG/$output_dir
prokka=$out/annotations/Prokka/flye/prokka.flye.gff
eggNOG=$out/annotations/eggNOG-mapper/flye/eggNOG.flye.emapper.genepred.gff

for f in $out/mapping/bwa/*.sorted.bam; do
	filename=$(echo $(basename $f) | cut -d'.' -f1)
	htseq-count -r pos -s no -t CDS --idattr=ID $f $eggNOG > "$out/read_counts_eggNOG/$output_dir/${filename}_readcount.out"
	htseq-count -r pos -s no -t CDS --idattr=ID $f <(sed '/^##FASTA/Q' $prokka) > "$out/read_counts/$output_dir/${filename}_readcount.out"
done
# ------------------------
set +x
