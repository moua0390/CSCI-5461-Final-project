# Unsupervised learning classifier — K-Means clustering

# Remember that in addition to these gene lists, we expect
# the SnC population to be more abundant (~ 5-20X or more abundant)
# in the samples derived from old mice relative to the young mice,
# which should also be incorporated into your scoring criteria.


install.packages("scales")
install.packages("stringr")
install.packages("useful")

library(scales)
library(stringr)
library(useful)

set.seed(54612024)

unsupervised_snc_classifier <- function(count_df, cell_ids, output_file="phase1_predictions.txt") {
  k = 30
  #k = ceiling(sqrt(nrow(count_df)) / 2)
  
  # Perform clustering
  kmeans_result <- kmeans(count_df[,-1], k)
  plot(kmeans_result)
  #print(kmeans_result)
  
  # Age criteria
  cell_ids <- meta_df$cell_ID
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
  cluster_scores <- sapply(1:k, function(nclust) {
    score <- 0
    
    # Retrieve the genes in the current cluster
    node_indexes <- which(kmeans_result$cluster == nclust)
    node_counts <- count_df[node_indexes,]
    
    # Check if any of the genes are the high abundance genes (Criteria 1)
    count_high_genes <- node_counts[node_counts$...1 %in% high_genes,]
    # Increment count for each match
    score <- score + nrow(count_high_genes)
    
    # Increment score if average number of high abundance genes in old cells
    # is greater than in young cells
    if (nrow(count_high_genes) > 0) {
      high_genes_in_old <- count_high_genes[,old_cells]
      high_genes_in_young <- count_high_genes[,young_cells]
      
      high_genes_in_old_avg <- rowMeans(high_genes_in_old)
      high_genes_in_young_avg <- rowMeans(high_genes_in_young)
      
      score <- score + sum(high_genes_in_old_avg > high_genes_in_young_avg)
    }
    
    # Check if any of the genes are the low abundance genes (Criteria 1)
    count_low_genes <- node_counts[node_counts$...1 %in% low_genes,]
    
    # Increment score if average number of low abundance genes in old cells
    # is less than in young cells or if none appear
    if (nrow(count_low_genes) > 0) {
      low_genes_in_old <- count_low_genes[,old_cells]
      low_genes_in_young <- count_low_genes[,young_cells]
      
      low_genes_in_old_avg <- rowMeans(low_genes_in_old)
      low_genes_in_young_avg <- rowMeans(low_genes_in_young)
      
      score <- score + sum(low_genes_in_old_avg < low_genes_in_young_avg)
    }
    else {
      score <- score + 1
    }
    
    # Final score
    return (score)
  })
  
  # Retrieves the cluster(s) with the highest score
  snc_clusters <- which(cluster_scores == max(cluster_scores))
  
  # Record likelihood scores
  scores_df <- data.frame(cell_ids)
  for (i in 1:length(snc_clusters)) {
    # Retrieve the center in the current cluster
    distances <- kmeans_result$centers[snc_clusters[i],]
    # Scale distances to be positive
    scaled_centers <- rescale(distances, to=c(0,1))
    # Append column with distance as score
    new_column <- paste("snc_cluster", snc_clusters[i], sep="")
    scores_df[[new_column]] <- 1 - scaled_centers
  }
  
  # Retrieve cells with an average high likelihood (>95%)
  snc_cells <- scores_df[rowMeans(scores_df[,-1]) > 0.95,]$cell_ids
  
  # Record cells with high likelihood to text file
  write.csv(data.frame(cell_ids=snc_cells), output_file, row.names=FALSE, quote=FALSE)
  
  # Return putative Senescent cell population
  return (snc_cells)
}
