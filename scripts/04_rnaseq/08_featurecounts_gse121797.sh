#!/bin/bash

# Generate gene-level count matrix for GSE121797 using featureCounts.

set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

GFF="$PROJECT_DIR/data/reference_genome/GCF_000009645.1/genomic.gff"
BAM_DIR="$PROJECT_DIR/results/rna_alignment/bam"
OUT_DIR="$PROJECT_DIR/results/featurecounts"

THREADS=6

mkdir -p "$OUT_DIR"

featureCounts \
    -T "$THREADS" \
    -p \
    -t CDS \
    -g ID \
    -a "$GFF" \
    -o "$OUT_DIR/GSE121797_counts.txt" \
    "$BAM_DIR/DAP_R_1C.sorted.bam" \
    "$BAM_DIR/DAP_R_3B.sorted.bam" \
    "$BAM_DIR/DAP_S_1A.sorted.bam" \
    "$BAM_DIR/DAP_S_3A.sorted.bam"

echo "GSE121797 featureCounts completed."