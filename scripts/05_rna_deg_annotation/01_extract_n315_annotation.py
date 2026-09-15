#!/usr/bin/env python3

"""
Extract CDS-level annotation from the S. aureus N315 GFF file.

Output columns:
- GeneID
- LocusTag
- GeneSymbol
- Product
"""

from pathlib import Path

import pandas as pd


PROJECT_DIR = Path(__file__).resolve().parents[2]

GFF_FILE = (
    PROJECT_DIR
    / "data"
    / "reference_genome"
    / "GCF_000009645.1"
    / "genomic.gff"
)

OUTPUT_FILE = (
    PROJECT_DIR
    / "results"
    / "rna_analysis"
    / "n315_annotation_with_symbols.csv"
)


def main() -> None:
    rows = []

    with GFF_FILE.open() as gff:
        for line in gff:
            if line.startswith("#"):
                continue

            columns = line.rstrip().split("\t")

            if len(columns) != 9:
                continue

            # Keep CDS entries only.
            if columns[2] != "CDS":
                continue

            attributes = {}

            for item in columns[8].split(";"):
                if "=" in item:
                    key, value = item.split("=", 1)
                    attributes[key] = value

            rows.append(
                {
                    "GeneID": attributes.get("ID", ""),
                    "LocusTag": attributes.get("locus_tag", ""),
                    "GeneSymbol": attributes.get("gene", ""),
                    "Product": attributes.get("product", ""),
                }
            )

    annotation = pd.DataFrame(rows)

    OUTPUT_FILE.parent.mkdir(parents=True, exist_ok=True)
    annotation.to_csv(OUTPUT_FILE, index=False)

    print(f"Annotation file saved to: {OUTPUT_FILE}")
    print(f"Total CDS annotated: {len(annotation)}")
    print("\nFirst 5 entries:")
    print(annotation.head())


if __name__ == "__main__":
    main()