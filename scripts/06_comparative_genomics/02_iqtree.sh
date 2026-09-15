#!/bin/bash

# Construct a phylogenetic tree from the Panaroo core-gene alignment
# using IQ-TREE.

set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

ALIGNMENT="$PROJECT_DIR/results/panaroo/output/core_gene_alignment_filtered.aln"
OUTPUT_DIR="$PROJECT_DIR/results/phylogeny"

IQTREE_BIN="${IQTREE_BIN:-iqtree3}"

mkdir -p "$OUTPUT_DIR"

"$IQTREE_BIN" \
    -s "$ALIGNMENT" \
    -m MFP \
    -B 1000 \
    -T AUTO \
    -pre "$OUTPUT_DIR/s_aureus_core"