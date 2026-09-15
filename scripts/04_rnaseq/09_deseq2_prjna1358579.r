# Differential expression analysis of PRJNA1358579 using DESeq2.

library(DESeq2)

sample_info <- data.frame(
  sample = c(
    "R103_B", "R103_P",
    "R19_B",  "R19_P",
    "R24_B",  "R24_P",
    "R78_B",  "R78_P"
  ),
  condition = c(
    "Biofilm", "Planktonic",
    "Biofilm", "Planktonic",
    "Biofilm", "Planktonic",
    "Biofilm", "Planktonic"
  )
)

sample_info$isolate <- c(
  "R103", "R103",
  "R19",  "R19",
  "R24",  "R24",
  "R78",  "R78"
)

rownames(sample_info) <- sample_info$sample

counts <- read.table(
  "results/featurecounts/PRJNA1358579_counts.txt",
  header = TRUE,
  sep = "\t",
  comment.char = "#",
  check.names = FALSE
)

count_matrix <- counts[, 7:14]

colnames(count_matrix) <- sample_info$sample
rownames(count_matrix) <- counts$Geneid

dds <- DESeqDataSetFromMatrix(
  countData = count_matrix,
  colData = sample_info,
  design = ~ isolate + condition
)

dds <- DESeq(dds)

res <- results(dds)

sig_res <- subset(res, padj < 0.1)

sig_df <- as.data.frame(sig_res)
sig_df$GeneID <- rownames(sig_df)

dir.create("results/deseq2", showWarnings = FALSE, recursive = TRUE)

write.csv(
  sig_df,
  "results/deseq2/PRJNA1358579_significant_DEGs.csv",
  row.names = FALSE
)