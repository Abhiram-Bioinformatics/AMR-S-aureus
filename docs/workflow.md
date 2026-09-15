# Workflow

## 1. Literature review and data collection

Publicly available *Staphylococcus aureus* datasets were collected from SRA, PATRIC/BV-BRC, and GEO.

- 3 WGS datasets from SRA
- 13 comparative genomes from PATRIC/BV-BRC
- 20 RNA-seq samples from three GEO studies
- sample metadata and analysis names were prepared before downstream processing

## 2. DNA preprocessing and genome assembly

Raw DNA reads were assessed with FastQC, trimmed with Trimmomatic, and assessed again with FastQC/MultiQC. Trimmed reads were assembled using SPAdes and assessed using QUAST.

The resulting assemblies were annotated with Prokka and the predicted protein sequences were used for downstream AMR identification.

## 3. AMR identification

CARD-RGI was run on the Prokka-predicted protein sequences. Individual RGI outputs were combined into a project-wide AMR table.

AMR genes were examined by occurrence, resistance mechanism, and drug class.

## 4. RNA-seq analysis

RNA-seq samples were processed according to their sequencing layout. FastQC/MultiQC were used for quality assessment, followed by HISAT2 alignment to the *S. aureus* N315 reference genome (GCF_000009645.1), SAMtools processing, and featureCounts quantification.

Differential expression analysis was performed with DESeq2 separately for the three studies.

DESeq2 results were subsequently annotated using the N315 reference annotation.

## 5. Comparative genomics

Annotated genomes were analysed using Panaroo for pangenome construction. The Panaroo core-gene alignment was used for phylogenetic reconstruction with IQ-TREE.

CARD-RGI AMR results were compared with the Panaroo gene presence/absence matrix to create an AMR pangenome summary.

## 6. Genomic context analysis

Genomic-context analyses were performed only for the three assembled SRA genomes.

### Web-based tools

- IslandViewer — genomic island prediction
- SCCmecFinder — SCCmec typing

### Local command-line analysis

- MobileElementFinder — mobile genetic element identification

The outputs from these analyses were interpreted together to assess genomic context and potential horizontal-transfer evidence.

## 7. Protein functional annotation

Seven priority AMR genes were selected for detailed protein-level analysis:

`mecA`, `norA`, `mepA`, `mepR`, `tet(38)`, `gyrA`, and `parC`.

Representative protein sequences were selected from CARD-RGI results and prepared locally as a FASTA file.

The FASTA file was then submitted to InterProScan through its web interface. The resulting annotations were used to construct the InterPro Summary Table.

## 8. Data integration

The Integrated AMR Evidence Table combined:

- CARD-RGI
- Panaroo
- RNA-seq differential expression
- InterProScan
- SCCmecFinder
- IslandViewer
- MobileElementFinder

STRING was used to investigate protein interaction/functional-association evidence for the selected AMR genes.

GO enrichment was performed with clusterProfiler using upregulated DEGs from PRJNA1358579, the RNA-seq dataset with the highest number of DEGs.

## 9. Interpretation

The final interpretation considered AMR gene occurrence, pangenome conservation, gene-expression evidence, protein function, genomic context, and protein interaction evidence together.

The integrated analysis is summarized in the final AMR Evidence Table and project report.
