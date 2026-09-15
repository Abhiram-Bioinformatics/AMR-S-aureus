#!/bin/bash

# Build a HISAT2 index for the S. aureus N315 reference genome.

set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

REFERENCE="$PROJECT_DIR/data/reference_genome/GCF_000009645.1/GCF_000009645.1_ASM964v1_genomic.fna"
INDEX_DIR="$PROJECT_DIR/data/reference_genome/GCF_000009645.1/hisat2_index"
INDEX_PREFIX="$INDEX_DIR/n315"

mkdir -p "$INDEX_DIR"

hisat2-build \
    "$REFERENCE" \
    "$INDEX_PREFIX"

echo "HISAT2 index created:"
echo "$INDEX_PREFIX"