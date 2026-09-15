#!/usr/bin/env python3

"""
Summarize protein sequence variation among selected AMR genes.

For each priority AMR gene:
- Count total RGI hits
- Count unique predicted protein sequences
"""

from pathlib import Path

import pandas as pd


PROJECT_DIR = Path(__file__).resolve().parents[2]

RGI_FILE = (
    PROJECT_DIR
    / "results"
    / "amr"
    / "combined_amr_results.tsv"
)

OUTPUT_FILE = (
    PROJECT_DIR
    / "results"
    / "amr"
    / "priority_amr_protein_variants.tsv"
)

PRIORITY_GENES = [
    "mecA",
    "norA",
    "mepA",
    "mepR",
    "tet(38)",
    "gyrA",
    "parC",
]


def main() -> None:
    df = pd.read_csv(RGI_FILE, sep="\t")

    rows = []

    for gene in PRIORITY_GENES:

        gene_df = df[
            df["Best_Hit_ARO"].str.contains(
                gene,
                case=False,
                na=False,
                regex=False,
            )
        ]

        total_proteins = len(gene_df)
        unique_proteins = gene_df["Predicted_Protein"].nunique()

        rows.append(
            {
                "Gene": gene,
                "Total_Proteins": total_proteins,
                "Unique_Protein_Variants": unique_proteins,
            }
        )

    result = pd.DataFrame(rows)

    OUTPUT_FILE.parent.mkdir(parents=True, exist_ok=True)

    result.to_csv(
        OUTPUT_FILE,
        sep="\t",
        index=False,
    )

    print("\nProtein Variant Summary\n")
    print(result)
    print(f"\nSaved as: {OUTPUT_FILE}")


if __name__ == "__main__":
    main()