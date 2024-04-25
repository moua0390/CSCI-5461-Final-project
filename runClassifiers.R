source("phase1.R")
source("phase2.R")
library(data.table)

setDTthreads(threads=0)

# Read data
integrated_df <- fread("./Integrated_scaled_counts_release.txt", verbose=TRUE)
heldout_df <- fread("./Phase2_masked_holdout_10k_integrated_scaled_counts.txt", verbose=TRUE)

unsupervised_scores <- unsupervised_snc_classifier(integrated_df)
supervised_scores <- supervised_snc_classifier(unsupervised_scores, heldout_df)

# Save scores to text files
write.csv(unsupervised_scores, "phase1_predictions.txt", quote=FALSE)
write.csv(supervised_scores, "phase2_predictions.txt", quote=FALSE)
