#!/bin/bash

# Extract GeneID-to-GO-term mappings from the N315 GFF.
# Supports both Ontology_term and go_function/go_process/go_component annotation styles.

set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

GFF_FILE="$PROJECT_DIR/data/reference_genome/GCF_000009645.1/genomic.gff"
OUTPUT_FILE="$PROJECT_DIR/results/go_gene_mapping.tsv"

mkdir -p "$(dirname "$OUTPUT_FILE")"

awk -F'\t' '
$3 == "CDS" {

    match($9, /ID=([^;]+)/, id)

    go_terms = ""

    if (match($9, /Ontology_term=([^;]+)/, go)) {
        go_terms = go[1]
    }

    if (match($9, /go_function=([^;]+)/, go)) {
        go_terms = (go_terms == "" ? "" : go_terms ",") go[1]
    }

    if (match($9, /go_process=([^;]+)/, go)) {
        go_terms = (go_terms == "" ? "" : go_terms ",") go[1]
    }

    if (match($9, /go_component=([^;]+)/, go)) {
        go_terms = (go_terms == "" ? "" : go_terms ",") go[1]
    }

    if (id[1] != "" && go_terms != "")
        print id[1] "\t" go_terms
}
' "$GFF_FILE" > "$OUTPUT_FILE"

echo "GO mapping written to:"
echo "$OUTPUT_FILE"