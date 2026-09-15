# GO enrichment analysis of PRJNA1358579 DEGs using clusterProfiler.

library(clusterProfiler)
library(dplyr)
library(tidyr)

deg_file <- "results/deseq2/PRJNA1358579_DEGs_annotated_with_symbols.csv"
go_map_file <- "results/go_gene_mapping.tsv"
counts_file <- "results/featurecounts/PRJNA1358579_counts.txt"

output_dir <- "results/go_enrichment"
dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)

# --------------------------------------------------
# Read DEG data
# --------------------------------------------------

deg <- read.csv(deg_file)

up_genes <- deg$GeneID[
  deg$log2FoldChange > 0 &
    deg$padj < 0.1
]

down_genes <- deg$GeneID[
  deg$log2FoldChange < 0 &
    deg$padj < 0.1
]

# --------------------------------------------------
# Read GO mapping
# --------------------------------------------------

go_map <- read.delim(
  go_map_file,
  header = FALSE,
  sep = "\t",
  col.names = c("GeneID", "GO_terms")
)

gene2go <- go_map %>%
  separate_rows(GO_terms, sep = ",") %>%
  rename(
    gene = GeneID,
    GO = GO_terms
  )

# --------------------------------------------------
# Define background universe
# --------------------------------------------------

counts <- read.delim(
  counts_file,
  comment.char = "#",
  check.names = FALSE
)

background_genes <- unique(counts$Geneid)

background_go <- go_map %>%
  filter(GeneID %in% background_genes)

universe_genes <- unique(background_go$GeneID)

up_genes_go <- intersect(up_genes, universe_genes)
down_genes_go <- intersect(down_genes, universe_genes)

cat("Upregulated genes with GO annotations:",
    length(up_genes_go), "\n")

cat("Downregulated genes with GO annotations:",
    length(down_genes_go), "\n")

cat("Background genes with GO annotations:",
    length(universe_genes), "\n")

# --------------------------------------------------
# Enrichment helper
# --------------------------------------------------

run_enrichment <- function(genes, universe) {

  if (length(genes) == 0) {
    return(NULL)
  }

  result <- enricher(
    gene = genes,
    universe = universe,
    TERM2GENE = gene2go[, c("GO", "gene")],
    pAdjustMethod = "BH",
    pvalueCutoff = 0.05,
    qvalueCutoff = 0.2
  )

  if (is.null(result)) {
    return(NULL)
  }

  result_df <- as.data.frame(result)

  if (nrow(result_df) == 0) {
    return(NULL)
  }

  result_df
}

ego_up <- run_enrichment(
  up_genes_go,
  universe_genes
)

ego_down <- run_enrichment(
  down_genes_go,
  universe_genes
)

# --------------------------------------------------
# Read GO descriptions from GFF
# --------------------------------------------------

gff <- readLines(
  "data/reference_genome/GCF_000009645.1/genomic.gff"
)

go_description <- unique(unlist(lapply(
  gff[grepl("go_function=|go_process=|go_component=", gff)],
  function(x) {

    fields <- unlist(strsplit(x, "\t"))

    if (length(fields) < 9) {
      return(character(0))
    }

    attributes <- fields[9]

    matches <- regmatches(
      attributes,
      gregexpr(
        "go_(function|process|component)=[^;]+",
        attributes
      )
    )[[1]]

    if (length(matches) == 0) {
      return(character(0))
    }

    unlist(lapply(matches, function(m) {
      terms <- sub("^[^=]+=", "", m)
      unlist(strsplit(terms, ","))
    }))
  }
)))

go_description_df <- do.call(
  rbind,
  lapply(go_description, function(x) {

    parts <- strsplit(x, "\\|")[[1]]

    if (length(parts) < 2) {
      return(NULL)
    }

    data.frame(
      Description_from_GFF = parts[1],
      GO = paste0("GO:", parts[2]),
      stringsAsFactors = FALSE
    )
  })
)

go_description_df <- unique(go_description_df)

# --------------------------------------------------
# Add descriptions and save results
# --------------------------------------------------

save_enrichment <- function(enrichment,
                            description_table,
                            output_file) {

  if (is.null(enrichment)) {
    message("No enriched GO terms to save for: ", output_file)
    return(invisible(NULL))
  }

  result <- enrichment %>%
    left_join(
      description_table,
      by = c("ID" = "GO")
    )

  if ("Description_from_GFF" %in% names(result)) {
    result$Description <- ifelse(
      is.na(result$Description_from_GFF),
      result$Description,
      result$Description_from_GFF
    )

    result$Description_from_GFF <- NULL
  }

  write.csv(
    result,
    output_file,
    row.names = FALSE
  )

  cat("Saved:", output_file, "\n")
}

save_enrichment(
  ego_up,
  go_description_df,
  file.path(
    output_dir,
    "PRJNA1358579_GO_enrichment_upregulated.csv"
  )
)

save_enrichment(
  ego_down,
  go_description_df,
  file.path(
    output_dir,
    "PRJNA1358579_GO_enrichment_downregulated.csv"
  )
)