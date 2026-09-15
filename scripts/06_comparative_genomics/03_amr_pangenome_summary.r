# Integrate Panaroo pangenome results with CARD-RGI AMR annotations.

library(readr)
library(dplyr)
library(stringr)

# --------------------------------------------------
# Read input files
# --------------------------------------------------

panaroo <- read_csv(
  "results/panaroo/output/gene_presence_absence.csv",
  show_col_types = FALSE
)

rgi <- read_tsv(
  "results/amr/combined_amr_results.tsv",
  show_col_types = FALSE
)

# --------------------------------------------------
# Remove Sample column if present
# --------------------------------------------------

if ("Sample" %in% names(rgi)) {
  rgi <- rgi %>% select(-Sample)
}

# --------------------------------------------------
# Detect genome columns automatically
# --------------------------------------------------

metadata_cols <- c(
  "Gene",
  "Non-unique Gene name",
  "Annotation"
)

genome_cols <- setdiff(names(panaroo), metadata_cols)

# --------------------------------------------------
# Count number of genomes containing each gene
# --------------------------------------------------

panaroo$No_of_Genomes <- apply(
  panaroo[, genome_cols],
  1,
  function(x) sum(!is.na(x) & x != "")
)

# --------------------------------------------------
# Assign pangenome category
# --------------------------------------------------

panaroo$PanGenome_Category <- case_when(
  panaroo$No_of_Genomes == length(genome_cols) ~ "Core",
  panaroo$No_of_Genomes >= 3 ~ "Shell",
  TRUE ~ "Cloud"
)

# --------------------------------------------------
# Clean Panaroo gene names
# --------------------------------------------------

result <- panaroo %>%
  rename(AMR_Gene = Gene)

result$AMR_Gene_clean <- result$AMR_Gene

# For merged clusters, keep the last gene name.
result$AMR_Gene_clean <- sub(
  ".*~~~",
  "",
  result$AMR_Gene_clean
)

# Remove suffixes such as _1, _2, _3.
result$AMR_Gene_clean <- sub(
  "_[0-9]+$",
  "",
  result$AMR_Gene_clean
)

# Recover selected genes stored as generic group IDs.
idx <- grepl(
  "^group_",
  result$AMR_Gene
)

result$AMR_Gene_clean[
  idx & grepl("\\bgyrA\\b", result$Annotation, ignore.case = TRUE)
] <- "gyrA"

result$AMR_Gene_clean[
  idx & grepl("\\bparC\\b", result$Annotation, ignore.case = TRUE)
] <- "parC"

result$AMR_Gene_clean[
  idx & grepl("\\bmecA\\b", result$Annotation, ignore.case = TRUE)
] <- "mecA"

# --------------------------------------------------
# Extract unique AMR information from RGI
# --------------------------------------------------

amr <- rgi %>%
  select(
    Best_Hit_ARO,
    `Drug Class`,
    `Resistance Mechanism`
  ) %>%
  distinct()

# --------------------------------------------------
# Merge Panaroo with RGI
# --------------------------------------------------

merged <- left_join(
  result,
  amr,
  by = c("AMR_Gene_clean" = "Best_Hit_ARO")
)

# --------------------------------------------------
# Keep only AMR genes
# --------------------------------------------------

merged <- merged %>%
  filter(!is.na(`Drug Class`))

# --------------------------------------------------
# Final summary table
# --------------------------------------------------

final <- merged %>%
  select(
    AMR_Gene = AMR_Gene_clean,
    No_of_Genomes,
    PanGenome_Category,
    `Drug Class`,
    `Resistance Mechanism`
  ) %>%
  distinct() %>%
  arrange(
    desc(No_of_Genomes),
    AMR_Gene
  )

# --------------------------------------------------
# Write output
# --------------------------------------------------

dir.create(
  "results/amr",
  showWarnings = FALSE,
  recursive = TRUE
)

write_csv(
  final,
  "results/amr/amr_pangenome_summary.csv"
)

cat("\nDone!\n")
cat("AMR genes identified:", nrow(final), "\n")