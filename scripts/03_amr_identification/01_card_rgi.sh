#!/bin/bash

# Identify antimicrobial resistance genes using CARD-RGI.
# Input: Prokka-predicted protein FASTA files (.faa)
# Output: RGI result files for each genome

set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

PROKKA_DIR="$PROJECT_DIR/results/prokka"
AMR_DIR="$PROJECT_DIR/results/amr"

THREADS=6

SAMPLES=(
    "ERR12712640"
    "ERR12712641"
    "ERR13347068"
    "9_1a"
    "614E"
    "0617SA27"
    "2018"
    "AUH_SA_2023"
    "H2_22S00635"
    "IL-064N"
    "IPD-029-1"
    "JARB_OU3000"
    "MRSA_MG10"
    "PD005"
    "sa230502_barcode25"
    "KWT_2020"
)

mkdir -p "$AMR_DIR"

for sample in "${SAMPLES[@]}"
do
    echo "Running CARD-RGI for $sample..."

    rgi main \
        --input_sequence "$PROKKA_DIR/$sample/$sample.faa" \
        --output_file "$AMR_DIR/$sample" \
        --input_type protein \
        --num_threads "$THREADS" \
        --local
done

echo "CARD-RGI analysis completed."