#!/bin/bash

# Align GSE121797 paired-end RNA-seq reads to the S. aureus N315
# reference using HISAT2, followed by SAMtools sorting and indexing.

set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

INDEX="$PROJECT_DIR/data/reference_genome/GCF_000009645.1/hisat2_index/n315"
TRIMMED_DIR="$PROJECT_DIR/data/rna/trimmed_fastq/paired_end"
OUT_DIR="$PROJECT_DIR/results/rna_alignment"

THREADS=6

SAMPLES=(
    "DAP_R_1C"
    "DAP_R_3B"
    "DAP_S_1A"
    "DAP_S_3A"
)

mkdir -p "$OUT_DIR/sam" "$OUT_DIR/bam" "$OUT_DIR/logs"

for sample in "${SAMPLES[@]}"
do
    echo "Processing $sample..."

    hisat2 \
        -p "$THREADS" \
        -x "$INDEX" \
        -1 "$TRIMMED_DIR/${sample}_1_paired.fastq.gz" \
        -2 "$TRIMMED_DIR/${sample}_2_paired.fastq.gz" \
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

echo "GSE121797 alignment completed."