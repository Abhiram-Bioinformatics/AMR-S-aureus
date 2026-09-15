#!/bin/bash

# Generate gene-level count matrix for GSE40864 using featureCounts.

set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

GFF="$PROJECT_DIR/data/reference_genome/GCF_000009645.1/genomic.gff"
BAM_DIR="$PROJECT_DIR/results/rna_alignment/bam"
OUT_DIR="$PROJECT_DIR/results/featurecounts"

THREADS=6

mkdir -p "$OUT_DIR"

featureCounts \
    -T "$THREADS" \
    -t CDS \
    -g ID \
    -a "$GFF" \
    -o "$OUT_DIR/GSE40864_counts.txt" \
    "$BAM_DIR/Control_2h_rep1.sorted.bam" \
    "$BAM_DIR/Control_2h_rep2.sorted.bam" \
    "$BAM_DIR/Control_2h_rep3.sorted.bam" \
    "$BAM_DIR/Control_2h_rep4.sorted.bam" \
    "$BAM_DIR/Vancomycin_2h_rep1.sorted.bam" \
    "$BAM_DIR/Vancomycin_2h_rep2.sorted.bam" \
    "$BAM_DIR/Vancomycin_2h_rep3.sorted.bam" \
    "$BAM_DIR/Vancomycin_2h_rep4.sorted.bam"

echo "GSE40864 featureCounts completed."