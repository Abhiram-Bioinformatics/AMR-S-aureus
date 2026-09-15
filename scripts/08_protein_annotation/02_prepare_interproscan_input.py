#!/usr/bin/env python3

"""
Prepare representative AMR protein sequences for InterProScan.

For each priority AMR gene:
- Identify RGI hits
- Remove duplicate genome/protein combinations
- Group identical protein sequences
- Assign variant IDs
- Select a representative genome
- Write a variant mapping table
- Write representative protein sequences as FASTA
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

OUTPUT_DIR = PROJECT_DIR / "results" / "interproscan"

MAPPING_FILE = OUTPUT_DIR / "amr_variant_mapping.tsv"
FASTA_FILE = OUTPUT_DIR / "interproscan_representative_proteins.fasta"

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

    mapping_rows = []
    fasta_records = []

    for gene in PRIORITY_GENES:

        gene_df = df[
            df["Best_Hit_ARO"].str.contains(
                gene,
                case=False,
                na=False,
                regex=False,
            )
        ].copy()

        if gene_df.empty:
            continue

        # Keep one occurrence for each genome/protein combination.
        gene_df = gene_df.drop_duplicates(
            subset=["Sample", "Predicted_Protein"]
        )

        # Group identical protein sequences.
        grouped = gene_df.groupby("Predicted_Protein")

        variant_number = 1

        for protein_seq, group in grouped:

            genomes = sorted(group["Sample"].unique())
            representative = genomes[0]

            variant_id = f"{gene}_V{variant_number}"

            mapping_rows.append(
                {
                    "Gene": gene,
                    "Variant_ID": variant_id,
                    "Representative_Genome": representative,
                    "Variant_Size": len(genomes),
                    "Protein_Length": len(protein_seq),
                    "Genomes": ", ".join(genomes),
                }
            )

            fasta_records.append(
                f">{variant_id}|{representative}\n{protein_seq}"
            )

            variant_number += 1

    mapping = pd.DataFrame(mapping_rows)
    mapping = mapping.sort_values(["Gene", "Variant_ID"])

    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)

    mapping.to_csv(
        MAPPING_FILE,
        sep="\t",
        index=False,
    )

    with FASTA_FILE.open("w") as fasta:
        fasta.write("\n".join(fasta_records))

    print("\nRepresentative protein FASTA created.")
    print(f"Total representative proteins: {len(fasta_records)}")

    print("\nFiles created:")
    print(f"  {MAPPING_FILE}")
    print(f"  {FASTA_FILE}")


if __name__ == "__main__":
    main()