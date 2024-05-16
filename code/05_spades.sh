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

source ../config.cfg
#modules
module load \
	bioinfo-tools \
	spades \


# Assembly of Illumina + PacBio using Spades
mkdir -p $out/assemblies/spades
out=$out/assemblies
il_read1=$in/Illumina/E745-1.L500_SZAXPI015146-56_1_clean.fq.gz
il_read2=$in/Illumina/E745-1.L500_SZAXPI015146-56_2_clean.fq.gz

# uncompress/unzip + recompress/zip all PB files into a new .fastq.gz for spades

zcat "$in/PacBio/*" | gzip > $"$out/PacBio_reads_compressed.fastq.gz"

spades.py -1 $il_read1 -2 $il_read2 --pacbio "$out/PacBio_reads_compressed.fastq.gz" -o $out/spades && rm "$out/PacBio_reads_compressed.fastq.gz"


