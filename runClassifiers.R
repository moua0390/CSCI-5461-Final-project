source("phase1.R")
source("phase2.R")
library(data.table)

# Read data
# integrated_data <- fread("./Senescence_project_data_2024/Integrated_scaled_counts_release.txt")
heldout_data <- fread("./Senescence_project_data_2024/Phase2_masked_holdout_10k_integrated_scaled_counts.txt")

supervised_scores <- supervised_snc_classifier(unsupervised_scores, heldout_data, 5)
