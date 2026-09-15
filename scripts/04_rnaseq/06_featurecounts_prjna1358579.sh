#!/bin/bash

# Generate gene-level count matrix for PRJNA1358579 using featureCounts.

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
    -o "$OUT_DIR/PRJNA1358579_counts.txt" \
    "$BAM_DIR/R103_B.sorted.bam" \
    "$BAM_DIR/R103_P.sorted.bam" \
    "$BAM_DIR/R19_B.sorted.bam" \
    "$BAM_DIR/R19_P.sorted.bam" \
    "$BAM_DIR/R24_B.sorted.bam" \
    "$BAM_DIR/R24_P.sorted.bam" \
    "$BAM_DIR/R78_B.sorted.bam" \
    "$BAM_DIR/R78_P.sorted.bam"

echo "PRJNA1358579 featureCounts completed."