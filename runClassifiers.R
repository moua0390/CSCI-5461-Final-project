source("phase1.R")
source("phase2.R")

install.packages("vroom")
library(vroom)

# Read data
integrated_df <- vroom("./Integrated_scaled_counts_release.txt")
meta_df <- vroom("./Metadata_release.txt")
heldout_df <- vroom("./Phase2_masked_holdout_10k_integrated_scaled_counts.txt")
senmayo_df <- vroom("senmayo.csv")
wechter_df <- vroom("wechter.csv")

# Perform unsupervised clustering
unsupervised_scores <- unsupervised_snc_classifier(integrated_df, wechter_df, senmayo_df, meta_df$cell_ID)

# Use unsupervised scores to perform supervised clustering
supervised_scores <- supervised_snc_classifier(integrated_df, unsupervised_scores$score, heldout_df)
