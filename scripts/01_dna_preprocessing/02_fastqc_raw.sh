#!/bin/bash

# Perform quality assessment of raw DNA sequencing reads using FastQC.

set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

RAW_DIR="$PROJECT_DIR/data/dna/raw_fastq"
QC_DIR="$PROJECT_DIR/data/dna/qc_reports/raw"

THREADS=6

mkdir -p "$QC_DIR"

fastqc \
    "$RAW_DIR"/*.fastq \
    -o "$QC_DIR" \
    -t "$THREADS"

echo "Raw-read FastQC completed."