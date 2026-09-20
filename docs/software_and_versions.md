# Software and tools

This document records the software/tools used in the project.


| Tool | Purpose |
|---|---|
| FastQC | Sequence quality assessment |
| MultiQC | QC report aggregation |
| Trimmomatic | Adapter and quality trimming |
| SRA Toolkit | SRA data retrieval and FASTQ conversion |
| SPAdes | De novo genome assembly |
| QUAST | Assembly quality assessment |
| Prokka | Genome annotation |
| CARD-RGI | AMR gene identification |
| HISAT2 | RNA-seq alignment and reference indexing |
| SAMtools | SAM/BAM processing |
| featureCounts | Gene-level read quantification |
| DESeq2 | Differential expression analysis |
| Panaroo | Pangenome analysis |
| IQ-TREE | Phylogenetic reconstruction |
| MobileElementFinder | Mobile genetic element identification |
| clusterProfiler | GO enrichment analysis |
| Python / pandas | Data processing and annotation utilities |
| R | Statistical analysis and data processing |
| IslandViewer | Genomic island prediction; web-based |
| SCCmecFinder | SCCmec typing; web-based |
| InterProScan | Protein functional annotation; web-based for this project |
| STRING | Protein interaction/functional association analysis |

## Reference genome

RNA-seq alignment and annotation used the *Staphylococcus aureus* N315 reference genome:

`GCF_000009645.1`

## Environment

Local command-line analyses were performed in a Linux-based environment using WSL during the project.

## Dependency note

The repository scripts assume the required tools are installed and available in the user's PATH. Installation commands and environment setup are intentionally kept separate from the main analysis scripts.
