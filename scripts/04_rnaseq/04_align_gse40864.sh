#!/bin/bash

# Align GSE40864 single-end RNA-seq reads to the S. aureus N315
# reference using HISAT2, followed by SAMtools sorting and indexing.

set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

INDEX="$PROJECT_DIR/data/reference_genome/GCF_000009645.1/hisat2_index/n315"
RAW_DIR="$PROJECT_DIR/data/rna/raw_fastq"
OUT_DIR="$PROJECT_DIR/results/rna_alignment"

THREADS=6

SAMPLES=(
    "Control_2h_rep1"
    "Control_2h_rep2"
    "Control_2h_rep3"
    "Control_2h_rep4"
    "Vancomycin_2h_rep1"
    "Vancomycin_2h_rep2"
    "Vancomycin_2h_rep3"
    "Vancomycin_2h_rep4"
)

mkdir -p "$OUT_DIR/sam" "$OUT_DIR/bam" "$OUT_DIR/logs"

for sample in "${SAMPLES[@]}"
do
    echo "Processing $sample..."

    hisat2 \
        -p "$THREADS" \
        -x "$INDEX" \
        -U "$RAW_DIR/${sample}.fastq.gz" \
        -S "$OUT_DIR/sam/${sample}.sam" \
        2> "$OUT_DIR/logs/${sample}.log"

    samtools sort \
        -@ "$THREADS" \
        -o "$OUT_DIR/bam/${sample}.sorted.bam" \
        "$OUT_DIR/sam/${sample}.sam"

    samtools index \
        "$OUT_DIR/bam/${sample}.sorted.bam"

    rm "$OUT_DIR/sam/${sample}.sam"
done

echo "GSE40864 alignment completed."