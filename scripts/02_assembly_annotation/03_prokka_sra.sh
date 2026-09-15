#!/bin/bash

# Genome annotation of assembled S. aureus genomes using Prokka.

set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

ASSEMBLY_DIR="$PROJECT_DIR/results/assembly"
PROKKA_DIR="$PROJECT_DIR/results/prokka"

THREADS=6

SAMPLES=(
    "ERR12712640"
    "ERR12712641"
    "ERR13347068"
)

mkdir -p "$PROKKA_DIR"

for sample in "${SAMPLES[@]}"
do
    echo "Annotating $sample..."

    prokka \
        --outdir "$PROKKA_DIR/$sample" \
        --prefix "$sample" \
        --genus Staphylococcus \
        --species aureus \
        --usegenus \
        --cpus "$THREADS" \
        "$ASSEMBLY_DIR/$sample/contigs.fasta"
done

echo "SRA genome annotation completed."