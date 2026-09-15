#!/bin/bash

# Download the three final WGS datasets used in the study.
# Run this script from the project repository.

set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

RAW_DIR="$PROJECT_DIR/data/dna/raw_fastq"
TMP_DIR="$PROJECT_DIR/tmp"

THREADS=6

SAMPLES=(
    "ERR12712640"
    "ERR12712641"
    "ERR13347068"
)

mkdir -p "$RAW_DIR" "$TMP_DIR"

for sample in "${SAMPLES[@]}"
do
    echo "Downloading $sample..."

    prefetch "$sample"

    fasterq-dump "$sample" \
        --outdir "$RAW_DIR" \
        --split-files \
        --threads "$THREADS" \
        --temp "$TMP_DIR"
done

echo "DNA data download completed."