#!/bin/bash -l

#SBATCH -A uppmax2024-2-7 
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 2
#SBATCH -t 03:30:00
#SBATCH -J Assembly_SPADES
#SBATCH --mail-type=ALL
#SBATCH --mail-user sam.hurenkamp.9631@student.uu.se


t=2

#modules
module load \
	bioinfo-tools \
	Spades \


base_dir=/home/samhur/1MB462-GenomeAnalysis/data
in=$base_dir/raw_data/genomics_data
out=$base_dir/metadata/QC/genomics_data

# Assembly of Illumina + PacBio using Spades


# Illumina
mkdir -p $out/assemblies/spades
out=$out/assemblies/spades
il_read1=$in/Illumina/E745-1.L500_SZAXPI015146-56_1_clean.fq.gz
il_read2=$in/Illumina/E745-1.L500_SZAXPI015146-56_2_clean.fq.gz

# uncompress/unzip + recompress/zip all PB files into a new .fastq.gz for spades
pb_compressed=$(zcat "$in/PacBio/*" | gzip > $"$out/PacBio_reads_compressed.fastq.gz")

spades -1 $read1 -2 $read2 --pacbio $pb_compressed -o $out && rm "$out/PacBio_reads_compressed.fastq.gz"
