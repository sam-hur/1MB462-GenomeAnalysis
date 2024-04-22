#!/bin/bash -l

#SBATCH -A uppmax2024-2-7 
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 8
#SBATCH -t 24:00:00
#SBATCH -J mapping_BWA
#SBATCH --mail-type=ALL
#SBATCH --mail-user sam.hurenkamp.9631@student.uu.se


t=8

#modules
module load \
	bioinfo-tools \
	bwa \
    samtools \

base_dir=/home/samhur/1MB462-GenomeAnalysis/data
in=$base_dir/raw_data/genomics_data
out=$base_dir/metadata/QC/genomics_data

target_dir=$out/mapping/bwa

mkdir -p $target_dir
assembly=$out/assemblies/flye/pb/assembly.fasta
assembly2=$out/assemblies/spades/contigs.fasta
ref=/home/samhur/1MB462-GenomeAnalysis/ref_genome
ref1=$ref/GCF_009734005.1/ref_NCBI.fna
ref2=$ref/GCA_009734005.2/ref_GenBank.fna # just optional alt.


set -x
# ------------------------
RNA_base=$base_dir/raw_data/transcriptomics_data
rna_refBH=${RNA_base}/RNA-seq_BH
rna_refSerum=${RNA_base}/RNA-seq_Serum/*.fastq.gz
out=$target_dir


declare -A RNA_ids  # id of sample pairs e.g., trim_paired_ERR1797971_pass_1 + trim_paired_ERR1797971_pass_2

RNA_cats=("RNA-Seq_BH" "RNA-Seq_Serum")
for f in "${RNA_cats[@]}"; do
	files=$(ls $RNA_base/$f/trim_paired_*_pass_*.fastq.gz | sort)

	for file in $files; do
		# echo $file
		err_id=$(basename "$file" | grep -oE 'ERR[0-9]+')
		RNA_ids["$err_id"]+=" $file"  # space adds a seperator
	done
done

bwa index $assembly  # create db
for key in "${!RNA_ids[@]}"; do  # for each key:value(filepaths) pair do:
    # echo "Key: $key, Value: ${RNA_ids[$key]}"
	values="${RNA_ids[$key]}"
	prefix="$(basename $(dirname $values[0]))_$key.mapped"
	echo $prefix

	bwa mem -t $t $assembly $values > $SNIC_TMP/$prefix.sam
	samtools view -bS $SNIC_TMP/$prefix.sam -bo $SNIC_TMP/$prefix.bam
	samtools sort $SNIC_TMP/$prefix.bam -o $out/$prefix.sorted.bam
	samtools index $out/$prefix.sorted.bam -o $out/$prefix.indexed.bai
done

# ------------------------
set +x
