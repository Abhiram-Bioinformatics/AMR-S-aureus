# Differential expression analysis of GSE40864 using DESeq2.

library(DESeq2)

sample_info <- data.frame(
  row.names = c(
    "Control_2h_rep1",
    "Control_2h_rep2",
    "Control_2h_rep3",
    "Control_2h_rep4",
    "Vancomycin_2h_rep1",
    "Vancomycin_2h_rep2",
    "Vancomycin_2h_rep3",
    "Vancomycin_2h_rep4"
  ),
  condition = c(
    "Control",
    "Control",
    "Control",
    "Control",
    "Vancomycin",
    "Vancomycin",
    "Vancomycin",
    "Vancomycin"
  )
)

counts <- read.table(
  "results/featurecounts/GSE40864_counts.txt",
  header = TRUE,
  sep = "\t",
  comment.char = "#",
  check.names = FALSE
)

count_matrix <- counts[, 7:14]

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
  "results/deseq2/GSE40864_DESeq2_results.csv",
  row.names = FALSE
)

write.csv(
  sig_res,
  "results/deseq2/GSE40864_significant_DEGs.csv",
  row.names = FALSE
)