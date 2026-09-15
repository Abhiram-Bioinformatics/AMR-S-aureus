#!/bin/bash

# Adapter and quality trimming of paired-end DNA reads using Trimmomatic.
#
# The adapter file is expected to be available to Trimmomatic.
# Set ADAPTER_FILE if it is stored at a custom location, for example:
#
# export ADAPTER_FILE="/path/to/NexteraPE-PE.fa"

set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

RAW_DIR="$PROJECT_DIR/data/dna/raw_fastq"
TRIMMED_DIR="$PROJECT_DIR/data/dna/trimmed_fastq"

THREADS=6

ADAPTER_FILE="${ADAPTER_FILE:-NexteraPE-PE.fa}"

mkdir -p "$TRIMMED_DIR"

for file in "$RAW_DIR"/*_1.fastq
do
    base="$(basename "$file" "_1.fastq")"

    echo "Trimming $base..."

    trimmomatic PE \
        -threads "$THREADS" \
        "$RAW_DIR/${base}_1.fastq" \
        "$RAW_DIR/${base}_2.fastq" \
        "$TRIMMED_DIR/${base}_1_paired.fastq" \
        "$TRIMMED_DIR/${base}_1_unpaired.fastq" \
        "$TRIMMED_DIR/${base}_2_paired.fastq" \
        "$TRIMMED_DIR/${base}_2_unpaired.fastq" \
        "$ADAPTER_FILE":2:40:15 \
        LEADING:5 \
        TRAILING:5 \
        SLIDINGWINDOW:4:20 \
        MINLEN:36
done

echo "DNA read trimming completed."