source("phase1.R")
source("phase2.R")

if (!require("vroom")) {
  install.packages("vroom")
  library(vroom)
}

if (!require("ggfortify")) {
  install.packages("ggfortify")
  library(ggfortify)
}

# Read data
integrated_df <- vroom("Integrated_scaled_counts_release.txt")
meta_df <- vroom("Metadata_release.txt")
heldout_df <- vroom("Phase2_masked_holdout_10k_integrated_scaled_counts.txt")
senmayo_df <- vroom("senmayo.csv")
wechter_df <- vroom("wechter.csv")

# Perform unsupervised classification
unsupervised_scores <- unsupervised_snc_classifier(integrated_df, wechter_df, senmayo_df, meta_df$cell_ID)

# Retrieve expression profiles of SnC genes (unsupervised results) only
train <- integrated_df[integrated_df$...1 %in% unlist(unsupervised_scores[1]),]
test <- heldout_df[heldout_df$...1 %in% unlist(unsupervised_scores[1]),]
train_scores <- unlist(unsupervised_scores[2])
supervised_scores <- supervised_snc_classifier(train, test, train_scores)

# Create PCA plot of supervised results
supervised_pca_result <- prcomp(t(test[,-1]), scale.=FALSE)
supervised_plot <- data.frame(score=as.numeric(supervised_scores["score",]))
autoplot(supervised_pca_result,
         scale=0,
         data=supervised_plot,
         color="score") +
  scale_colour_gradient(low="blue", high="red", "Score") +
  ggtitle("2D PCA plot from Supervised SnC classifier scores") +
  theme(plot.title=element_text(hjust = 0.5))
