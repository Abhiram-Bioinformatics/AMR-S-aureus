#!/bin/bash

# RNA-seq adapter and quality trimming using Trimmomatic.
#
# PRJNA1358579 and GSE121797 were trimmed.
# GSE40864 was not trimmed.

set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

RAW_DIR="$PROJECT_DIR/data/rna/raw_fastq"
TRIMMED_DIR="$PROJECT_DIR/data/rna/trimmed_fastq/paired_end"

THREADS=6
ADAPTER_FILE="${ADAPTER_FILE:-NexteraPE-PE.fa}"

mkdir -p "$TRIMMED_DIR"

SAMPLES=(
    "DAP_R_1C"
    "DAP_R_3B"
    "DAP_S_1A"
    "DAP_S_3A"
    "R103_B"
    "R103_P"
    "R19_B"
    "R19_P"
    "R24_B"
    "R24_P"
    "R78_B"
    "R78_P"
)

for sample in "${SAMPLES[@]}"
do
    echo "Trimming $sample..."

    trimmomatic PE \
        -threads "$THREADS" \
        "$RAW_DIR/${sample}_1.fastq.gz" \
        "$RAW_DIR/${sample}_2.fastq.gz" \
        "$TRIMMED_DIR/${sample}_1_paired.fastq.gz" \
        "$TRIMMED_DIR/${sample}_1_unpaired.fastq.gz" \
        "$TRIMMED_DIR/${sample}_2_paired.fastq.gz" \
        "$TRIMMED_DIR/${sample}_2_unpaired.fastq.gz" \
        "$ADAPTER_FILE":2:40:15 \
        LEADING:5 \
        TRAILING:5 \
        SLIDINGWINDOW:4:20 \
        MINLEN:36
done

echo "RNA-seq trimming completed."