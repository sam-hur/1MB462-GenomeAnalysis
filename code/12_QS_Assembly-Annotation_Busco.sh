#!/bin/bash -l

#SBATCH -A uppmax2024-2-7 
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 8
#SBATCH -t 24:00:00
#SBATCH -J qc_assembly-annotation_Busco
#SBATCH --mail-type=ALL
#SBATCH --mail-user sam.hurenkamp.9631@student.uu.se


t=8


source ../config.cfg

#modules
module load \
	bioinfo-tools \
	BUSCO/5.5.0 \


source $AUGUSTUS_CONFIG_COPY

assembly=$out/assemblies/flye/pb/assembly.fasta
assembly2=$out/assemblies/spades/contigs.fasta

mkdir $out/busco
# ------------------------
#   BUSCO: ASSEMBLY
# ------------------------

run_busco () {
    mode="${3:-genome}"
    busco -i $1 -o $2 -l $BUSCO_LINEAGE_SETS/bacteria -m $mode -c $t \
    --out_path $out/busco \
    --download_path $out/busco \
    --force
}


# ---- Reference
prefix=reference.busco
    # busco -i $ref -o $prefix -l $BUSCO_LINEAGE_SETS/bacteria -m genome -c $t --out_dir $out/busco
run_busco $ref $prefix
cp -r $out/busco/$prefix $out/assemblies_QC


# ---- Flye
prefix=flye.busco
# busco -i $assembly -o flye.busco -l $BUSCO_LINEAGE_SETS/bacteria -m genome -c $t --out_dir $out/busco
run_busco $assembly $prefix
cp -r $out/busco/$prefix $out/assemblies_QC

# ---- Spades
prefix=spades.busco
# busco -i $assembly2 -o spades.busco -l $BUSCO_LINEAGE_SETS/bacteria -m genome -c $t --out_dir $out/busco
run_busco $assembly2 $prefix
cp -r $out/busco/$prefix $out/assemblies_QC

# ------------------------
#   BUSCO: ANNOTATION
# ------------------------
mkdir -p $out/annotations_QC
# ---- Flye
prefix=prokka.flye.busco
# busco -i prokka.flye.busco -o $out/annotations_QC/flye.busco -l $BUSCO_LINEAGE_SETS/bacteria -m genome -c $t --out_dir $out/busco # faa
run_busco $out/annotations/Prokka/flye/prokka.flye.faa $prefix proteins
cp -r $out/busco/$prefix $out/annotations_QC
