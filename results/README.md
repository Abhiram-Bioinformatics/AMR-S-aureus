# Results

This directory contains selected final outputs from the *Staphylococcus aureus* antimicrobial-resistance project.

The complete supplementary data workbook is organized into Supplementary Tables S1–S9 and contains the principal tabulated results generated during the study.

## Supplementary tables

### Dataset metadata

* **S1A — Genomic metadata**
  Metadata for the 3 SRA-derived study genomes and 13 comparative BV-BRC genomes.

* **S1B — RNA-seq metadata**
  Metadata for the 20 RNA-seq samples from the three analysed studies.

### Genome assembly and AMR analysis

* **S2 — QUAST statistics**
  Complete assembly statistics for the three retained SRA-derived genomes.

* **S3A — AMR gene prevalence**
  Genome-level prevalence of CARD-RGI best-hit AMR genes across the 16-genome dataset.

* **S3B — Resistance mechanism and drug-class frequencies**
  Frequencies of CARD-RGI resistance-mechanism and drug-class annotations.

### RNA-seq differential expression

* **S4A — GSE40864 significant DEGs**
* **S4B — GSE121797 significant DEG**
* **S4C — PRJNA1358579 significant DEGs**

These tables contain the significant differentially expressed genes identified in each RNA-seq study together with their gene identifiers, annotations, fold changes, adjusted p-values, and regulation status.

### Comparative genomics

* **S5A — AMR presence/absence matrix**
  Binary presence/absence of AMR gene families across the 16 analysed genomes.

* **S5B — AMR pangenome classification**
  Panaroo-based classification of selected AMR genes according to their distribution across the analysed genomes.

### Genomic context

* **S6A — IslandViewer results**
* **S6B — SCCmecFinder results**
* **S6C — MobileElementFinder results**
* **S6D — Combined genomic-context summary**

These tables summarize genomic islands, SCCmec types, mobile genetic elements, and their combined interpretation for the three assembled SRA genomes.

### Protein functional annotation

* **S7 — InterProScan summary**
  Functional annotation of representative proteins corresponding to the seven selected AMR genes.

### Functional enrichment

* **S8A — GO enrichment**
* **S8B — Enriched-gene mapping**

These tables contain the GO enrichment results for the upregulated genes from PRJNA1358579 and the gene identifiers contributing to the enriched terms.

### Integrated AMR evidence

* **S9 — Integrated AMR evidence**
  Gene-wise integration of CARD-RGI, Panaroo, RNA-seq, InterProScan, SCCmecFinder, IslandViewer, and MobileElementFinder evidence for the seven priority AMR genes.

## Figures

The principal figures generated during the project should be placed in `figures/`. These include:

1. Genome assembly quality / QUAST summary
2. AMR gene distribution heatmap
3. Resistance-mechanism distribution
4. Core-genome phylogenetic tree
5. AMR pangenome heatmap
6. Integrated genomic-context summary
7. STRING protein-interaction network
8. GO enrichment plot
9. Integrated AMR evidence matrix

Only final figures should be included here. Raw plots, temporary graphics, and intermediate visualization files do not need to be committed.

## Large intermediate files

Large raw and intermediate files are intentionally excluded from this directory. This includes raw FASTQ files, SAM/BAM files, SPAdes intermediate directories, complete Prokka output directories, and other large tool-generated files.

The repository instead retains the analysis scripts, metadata, selected final results, and documentation required to understand the workflow.

## Supplementary workbook

The complete supplementary tables accompanying the project report are provided in:

`Supplementary_Data.xlsx`

