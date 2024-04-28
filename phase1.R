# Unsupervised learning classifier — K-Means clustering

# Remember that in addition to these gene lists, we expect
# the SnC population to be more abundant (~ 5-20X or more abundant)
# in the samples derived from old mice relative to the young mice,
# which should also be incorporated into your scoring criteria.

install.packages("stringr")
install.packages("useful")

library(stringr)
library(useful)

set.seed(54612024)

unsupervised_snc_classifier <- function(count_df, cell_ids) {
  k = 30
  #k = ceiling(sqrt(nrow(count_df)) / 2)
  
  # Perform clustering
  kmeans_result <- kmeans(count_df[,-1], k)
  plot(kmeans_result)
  print(kmeans_result)
  
  # Age criteria
  old_cells <- cell_ids[str_detect(cell_ids, "1_1|1_2|1_3")]
  young_cells <- cell_ids[str_detect(cell_ids, "1_4|1_5|1_6")]
  
  # Criteria based on Study 1
  high_genes <- c("Cdkn2a", "E2f2", "Tnf", "Lmnb1", "Il10", "Il1b", "Bst1", "Irg1", "Parp14", "Itgax", "Itgam")
  low_genes <- c("Sulf2", "Angptl2", "Sirt4", "Sirt3", "Nnmt", "Sirt5", "Bcl2l2", "Nmnat1", "Nampt", "Parp6", "Igfbp2", "Parp3")

  # TODO: Criteria based on Study 2
  # Looking for...

  # TODO: Criteria based on Study 3
  # Looking for Secreted state and...
  
  # TODO: Score the resulting clusters
  cluster_scores <- sapply(1:k, function(i) {
    node_indexes <- which(kmeans_result_30$cluster == i)
    node_counts <- integrated_df[node_indexes,]
    
    node_high_genes <- node_counts[node_counts$...1 %in% high_genes,]
    node_low_genes <- node_counts[node_counts$...1 %in% low_genes,]
    
    score <- nrow(node_high_genes) + nrow(node_low_genes)
  })
  
  # Retrieves the cluster(s) with the highest score
  snc_clusters <- which(cluster_scores == max(cluster_scores))
}
