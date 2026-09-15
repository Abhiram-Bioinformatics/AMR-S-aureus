# Bioinformatics Approaches to Investigate Antimicrobial Resistance in *Staphylococcus aureus*

This repository contains the computational workflow, metadata, selected results, and documentation for the project **Bioinformatics Approaches to Investigate Antimicrobial Resistance in *Staphylococcus aureus***.

## Project overview

The study used an integrated bioinformatics workflow to investigate antimicrobial resistance (AMR) in *Staphylococcus aureus* from complementary genomic, transcriptomic, comparative-genomic, genomic-context, and protein-functional perspectives.

The project included:

- 3 whole-genome sequencing datasets from the NCBI Sequence Read Archive (SRA)
- 13 complete or high-quality *S. aureus* reference genomes from PATRIC/BV-BRC
- 20 RNA-seq samples from three GEO studies
- genome assembly and annotation
- AMR gene identification using CARD-RGI
- RNA-seq alignment, quantification, and differential expression analysis
- pangenome and phylogenetic analysis
- genomic-context analysis
- representative AMR protein functional annotation
- protein interaction analysis
- GO enrichment analysis
- integration of multiple lines of AMR evidence

## Main study questions

The workflow was designed to investigate:

1. Which AMR genes and resistance mechanisms occur across the analysed *S. aureus* genomes?
2. Which AMR determinants are conserved or variably distributed across the pangenome?
3. What genomic context and mobile-element associations occur around AMR determinants in the assembled genomes?
4. Which genes are differentially expressed under the experimental conditions represented by the RNA-seq datasets?
5. What functional characteristics are associated with selected AMR proteins?
6. How can genomic, transcriptomic, protein-level, and genomic-context evidence be integrated for biological interpretation?

## Datasets

### Whole-genome sequencing

Three WGS datasets from SRA were assembled as the primary study genomes:

- ERR12712640
- ERR12712641
- ERR13347068

Thirteen *S. aureus* genomes obtained from PATRIC/BV-BRC were included as comparative reference genomes.

See:

- `metadata/dna_sra_samples.tsv`
- `metadata/dna_bvbrc_samples.tsv`

### RNA-seq

Twenty RNA-seq samples from three GEO studies were analysed:

- PRJNA1358579 — 8 samples
- GSE40864 — 8 samples
- GSE121797 — 4 samples

See `metadata/rna_samples.tsv`.

## Workflow

```text
Public dataset collection
        |
        +--> DNA WGS
        |      |
        |      +--> FastQC / trimming / MultiQC
        |      +--> SPAdes assembly
        |      +--> QUAST
        |      +--> Prokka
        |      +--> CARD-RGI
        |      +--> Panaroo
        |      +--> IQ-TREE
        |      +--> IslandViewer / SCCmecFinder / MobileElementFinder
        |
        +--> RNA-seq
               |
               +--> FastQC / trimming / MultiQC
               +--> HISAT2
               +--> SAMtools
               +--> featureCounts
               +--> DESeq2
               +--> DEG annotation
               +--> GO enrichment for PRJNA1358579

Selected AMR proteins
        |
        +--> representative protein selection
        +--> InterProScan
        +--> InterPro summary

Multiple outputs
        |
        +--> Integrated AMR Evidence Table
        +--> STRING analysis
```

## Repository structure

```text
metadata/        Dataset and sample metadata
scripts/         Reproducible analysis scripts
docs/            Workflow and tool documentation
results/         Selected final figures and tables
report/          Final project report
```

## Computational environment

The command-line analyses were performed in a Linux-based environment using open-source bioinformatics software, with WSL used for the local workflow during project execution.

The repository separates:

- local command-line analyses, provided as scripts
- web-based analyses, documented in `docs/web_based_analyses.md`
- downstream manual/integrative outputs, documented in the workflow and results sections

## Important reproducibility note

The repository is intended primarily as a transparent record and reusable reference for the analysis performed in this project. It is not intended to provide a one-command automated pipeline for reproducing every analysis.

Large raw sequencing files and large intermediate files are not included in the repository. Dataset accession information and metadata are provided instead.

## Key results

The study identified conserved and variable AMR determinants across the 16 analysed genomes, including a set of seven priority AMR genes selected for detailed downstream interpretation:

- `mecA`
- `norA`
- `mepA`
- `mepR`
- `tet(38)`
- `gyrA`
- `parC`

Comparative genomics identified conserved AMR-associated genes as well as variably distributed determinants. Genomic-context analysis identified SCCmec types and mobile genetic elements in the three assembled SRA genomes. RNA-seq analysis identified differentially expressed genes across the three independent studies, and GO enrichment of upregulated genes from PRJNA1358579 highlighted ribosome- and translation-associated functions. Protein functional annotation and STRING analysis provided additional functional context for the selected AMR proteins.

## Limitations

This project is entirely computational and relies on public datasets and curated databases. The results therefore represent bioinformatic predictions and annotations and were not experimentally validated through antimicrobial susceptibility testing, quantitative expression assays, or protein functional studies.

The genomic and transcriptomic datasets originated from independent studies and should not be interpreted as measurements from the same bacterial isolates.

## Report

The complete project report is provided in `report/`.

## Author

**Abhiram K**

Project completed through Biotecnika Info Labs  
August 2026
