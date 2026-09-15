#!/bin/bash

# Pangenome analysis of the S. aureus genomes using Panaroo.


set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

PROKKA_DIR="$PROJECT_DIR/results/prokka"
PANAROO_DIR="$PROJECT_DIR/results/panaroo"

THREADS=8

mkdir -p "$PANAROO_DIR"

GFF_LIST="$PANAROO_DIR/gff_list.txt"

find "$PROKKA_DIR" \
    -name "*.gff" \
    | grep -Ev "ERR12716605|ERR12716606" \
    | sort \
    > "$GFF_LIST"

panaroo \
    -i $(cat "$GFF_LIST") \
    -o "$PANAROO_DIR/output" \
    --clean-mode moderate \
    --aligner mafft \
    -t "$THREADS"

echo "Panaroo pangenome analysis completed."