# Differential expression analysis of GSE121797 using DESeq2.

library(DESeq2)

sample_info <- data.frame(
  row.names = c(
    "DAP_R_1C",
    "DAP_R_3B",
    "DAP_S_1A",
    "DAP_S_3A"
  ),
  condition = c(
    "Resistant",
    "Resistant",
    "Susceptible",
    "Susceptible"
  )
)

counts <- read.table(
  "results/featurecounts/GSE121797_counts.txt",
  header = TRUE,
  sep = "\t",
  comment.char = "#",
  check.names = FALSE
)

count_matrix <- counts[, 7:10]

colnames(count_matrix) <- rownames(sample_info)
rownames(count_matrix) <- counts$Geneid

dds <- DESeqDataSetFromMatrix(
  countData = count_matrix,
  colData = sample_info,
  design = ~ condition
)

dds <- DESeq(dds)

res <- results(dds)

res_df <- as.data.frame(res)
res_df$GeneID <- rownames(res_df)

sig_res <- subset(res_df, padj < 0.1)

dir.create("results/deseq2", showWarnings = FALSE, recursive = TRUE)

write.csv(
  res_df,
  "results/deseq2/GSE121797_DESeq2_results.csv",
  row.names = FALSE
)

write.csv(
  sig_res,
  "results/deseq2/GSE121797_significant_DEGs.csv",
  row.names = FALSE
)