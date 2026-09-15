#!/bin/bash

# Genome annotation of the 13 reference genomes obtained from PATRIC/BV-BRC.

set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

PATRIC_DIR="$PROJECT_DIR/data/dna/patric_genomes"
PROKKA_DIR="$PROJECT_DIR/results/prokka"

THREADS=6

mkdir -p "$PROKKA_DIR"

for file in "$PATRIC_DIR"/*.fasta
do
    sample="$(basename "$file" .fasta)"

    echo "Annotating $sample..."

    prokka \
        --outdir "$PROKKA_DIR/$sample" \
        --prefix "$sample" \
        --genus Staphylococcus \
        --species aureus \
        --usegenus \
        --cpus "$THREADS" \
        "$file"
done

echo "PATRIC genome annotation completed."