#!/usr/bin/env python3

"""
Annotate significant GSE40864 DEGs with N315 gene information.
"""

from pathlib import Path

import pandas as pd


PROJECT_DIR = Path(__file__).resolve().parents[2]

DEG_FILE = (
    PROJECT_DIR
    / "results"
    / "deseq2"
    / "GSE40864_significant_DEGs.csv"
)

ANNOTATION_FILE = (
    PROJECT_DIR
    / "results"
    / "rna_analysis"
    / "n315_annotation_with_symbols.csv"
)

OUTPUT_FILE = (
    PROJECT_DIR
    / "results"
    / "deseq2"
    / "GSE40864_DEGs_annotated_with_symbols.csv"
)


def main() -> None:
    deg = pd.read_csv(DEG_FILE)
    annotation = pd.read_csv(ANNOTATION_FILE)

    merged = deg.merge(
        annotation,
        on="GeneID",
        how="left",
    )

    OUTPUT_FILE.parent.mkdir(parents=True, exist_ok=True)
    merged.to_csv(OUTPUT_FILE, index=False)

    print(f"Total DEGs: {len(merged)}")
    print(f"Annotated: {merged['Product'].notna().sum()}")
    print(f"Output saved to: {OUTPUT_FILE}")

    print("\nFirst 5 rows:")
    print(merged.head())


if __name__ == "__main__":
    main()