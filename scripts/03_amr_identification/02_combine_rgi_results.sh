#!/bin/bash

# Combine CARD-RGI results from all genomes into a single TSV file.
# The sample/genome name is added as the first column.

set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

AMR_DIR="$PROJECT_DIR/results/amr"
OUTPUT="$AMR_DIR/combined_amr_results.tsv"

cd "$AMR_DIR"

# Add the new Sample column to the header.
printf "Sample\t" > "$OUTPUT"
head -n 1 ERR12712640.txt >> "$OUTPUT"

for file in *.txt
do
    sample="$(basename "$file" .txt)"

    tail -n +2 "$file" |
        awk -v s="$sample" 'BEGIN {FS=OFS="\t"} {print s,$0}' \
        >> "$OUTPUT"
done

echo "Combined RGI results written to:"
echo "$OUTPUT"