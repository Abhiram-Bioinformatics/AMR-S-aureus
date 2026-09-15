#!/bin/bash

# Align PRJNA1358579 RNA-seq reads to the S. aureus N315 reference
# using HISAT2, followed by BAM sorting and indexing with SAMtools.

set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

INDEX="$PROJECT_DIR/data/reference_genome/GCF_000009645.1/hisat2_index/n315"
RAW_DIR="$PROJECT_DIR/data/rna/raw_fastq"
OUT_DIR="$PROJECT_DIR/results/rna_alignment"

THREADS=6

SAMPLES=(
    "R103_B"
    "R103_P"
    "R19_B"
    "R19_P"
    "R24_B"
    "R24_P"
    "R78_B"
    "R78_P"
)

mkdir -p "$OUT_DIR/sam" "$OUT_DIR/bam" "$OUT_DIR/logs"

for sample in "${SAMPLES[@]}"
do
    echo "Processing $sample..."

    hisat2 \
        -p "$THREADS" \
        -x "$INDEX" \
        -1 "$RAW_DIR/${sample}_1_paired.fastq.gz" \
        -2 "$RAW_DIR/${sample}_2_paired.fastq.gz" \
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

echo "PRJNA1358579 alignment completed."