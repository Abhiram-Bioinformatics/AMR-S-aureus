#!/bin/bash

# Perform quality assessment of trimmed DNA reads using FastQC
# and summarize the reports using MultiQC.

set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

TRIMMED_DIR="$PROJECT_DIR/data/dna/trimmed_fastq"
QC_DIR="$PROJECT_DIR/data/dna/qc_reports/trimmed"

THREADS=6

mkdir -p "$QC_DIR"

fastqc \
    "$TRIMMED_DIR"/*_paired.fastq \
    -o "$QC_DIR" \
    -t "$THREADS"

multiqc "$QC_DIR" -o "$QC_DIR"

echo "Trimmed-read FastQC and MultiQC completed."