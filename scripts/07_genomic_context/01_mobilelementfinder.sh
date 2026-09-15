#!/bin/bash

# Identify mobile genetic elements in the three S. aureus SRA genomes
# using MobileElementFinder.

set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

ASSEMBLY_DIR="$PROJECT_DIR/results/assembly"
OUTPUT_DIR="$PROJECT_DIR/results/mobileelementfinder"

THREADS=4

SAMPLES=(
    "ERR12712640"
    "ERR12712641"
    "ERR13347068"
)

mkdir -p "$OUTPUT_DIR"

for sample in "${SAMPLES[@]}"
do
    echo "Running MobileElementFinder for $sample..."

    mefinder find \
        -c "$ASSEMBLY_DIR/$sample/contigs.fasta" \
        -g \
        -j \
        -t "$THREADS" \
        "$OUTPUT_DIR/$sample"
done

echo "MobileElementFinder analysis completed."