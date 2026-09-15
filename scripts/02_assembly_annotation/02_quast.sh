#!/bin/bash

# Assess assembly quality using QUAST.

set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

ASSEMBLY_DIR="$PROJECT_DIR/results/assembly"
QUAST_DIR="$PROJECT_DIR/results/quast"

THREADS=6

SAMPLES=(
    "ERR12712640"
    "ERR12712641"
    "ERR13347068"
)

mkdir -p "$QUAST_DIR"

for sample in "${SAMPLES[@]}"
do
    echo "Running QUAST for $sample..."

    quast.py \
        "$ASSEMBLY_DIR/$sample/contigs.fasta" \
        -o "$QUAST_DIR/$sample" \
        --threads "$THREADS"
done

echo "QUAST analysis completed."