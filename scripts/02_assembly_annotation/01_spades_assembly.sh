#!/bin/bash

# Genome assembly of the final SRA datasets using SPAdes.
#
# Paired reads are supplied separately.
# The two unpaired read files are first combined into a single file,
# because SPAdes accepts one file for the -s option.

set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

TRIMMED_DIR="$PROJECT_DIR/data/dna/trimmed_fastq"
ASSEMBLY_DIR="$PROJECT_DIR/results/assembly"
TMP_DIR="$PROJECT_DIR/tmp"

THREADS=6
MEMORY=12

SAMPLES=(
    "ERR12712640"
    "ERR12712641"
    "ERR13347068"
)

mkdir -p "$ASSEMBLY_DIR" "$TMP_DIR"

for sample in "${SAMPLES[@]}"
do
    echo "Assembling $sample..."

    cat \
        "$TRIMMED_DIR/${sample}_1_unpaired.fastq" \
        "$TRIMMED_DIR/${sample}_2_unpaired.fastq" \
        > "$TRIMMED_DIR/${sample}_unpaired.fastq"

    spades.py \
        --isolate \
        -1 "$TRIMMED_DIR/${sample}_1_paired.fastq" \
        -2 "$TRIMMED_DIR/${sample}_2_paired.fastq" \
        -s "$TRIMMED_DIR/${sample}_unpaired.fastq" \
        -o "$ASSEMBLY_DIR/$sample" \
        --threads "$THREADS" \
        --memory "$MEMORY" \
        --tmp-dir "$TMP_DIR"

done

echo "SPAdes assembly completed."