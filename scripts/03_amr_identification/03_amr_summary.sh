#!/bin/bash

# Generate frequency summaries from the combined CARD-RGI results.

set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

AMR_DIR="$PROJECT_DIR/results/amr"
INPUT="$AMR_DIR/combined_amr_results.tsv"

# Drug class frequency
cut -f 15 "$INPUT" |
    sort |
    uniq -c |
    sort -nr \
    > "$AMR_DIR/drug_class_frequency.txt"

# AMR gene / ARO name frequency
cut -f 2,11 "$INPUT" |
    sort |
    uniq |
    cut -f 2 |
    sort |
    uniq -c |
    sort -nr \
    > "$AMR_DIR/gene_frequency.txt"

echo "AMR summary files created."