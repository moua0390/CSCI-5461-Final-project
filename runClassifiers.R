source("phase1.R")
source("phase2.R")

install.packages("vroom")
library(vroom)

# Read data
integrated_df <- vroom("./Integrated_scaled_counts_release.txt")
meta_df <- vroom("./Metadata_release.txt")
heldout_df <- vroom("./Phase2_masked_holdout_10k_integrated_scaled_counts.txt")

unsupervised_scores <- unsupervised_snc_classifier(integrated_df, meta_df$cell_ID)
supervised_scores <- supervised_snc_classifier(unsupervised_scores, heldout_df)

# Save scores to text files
write.csv(unsupervised_scores, "phase1_predictions.txt", quote=FALSE)
write.csv(supervised_scores, "phase2_predictions.txt", quote=FALSE)
