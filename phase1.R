# Unsupervised learning classifier — K-Means clustering

if (!require("ggfortify")) {
  install.packages("ggfortify")
  library(ggfortify)
}

if (!require("scales")) {
  install.packages("scales")
  library(scales)
}

if (!require("stringr")) {
  install.packages("stringr")
  library(stringr)
}

set.seed(54612024)

unsupervised_snc_classifier <- function(count_df, wechter_df, senmayo_df, cell_ids, k=30, output_file="phase1_predictions.txt") {
  # Perform clustering
  kmeans_result <- kmeans(count_df[,-1], k)
  
  # The following code creates a cluster plot.
  # Commented out to reduce runtime.
  # autoplot(kmeans_result, data=count_df[,-1], scale.=FALSE, frame.type="norm") +
  #   ggtitle(paste("2D PCA plot from K-Means with", k, "clusters")) +
  #   theme(plot.title=element_text(hjust=0.5))
  
  # Age criteria
  old_cells <- cell_ids[str_detect(cell_ids, "1_1|1_2|1_3")]
  young_cells <- cell_ids[str_detect(cell_ids, "1_4|1_5|1_6")]
  
  # Criteria based on Study 1
  high_genes <- c("Cdkn2a", "E2f2", "Tnf", "Lmnb1", "Il10", "Il1b", "Bst1", "Irg1", "Parp14", "Itgax", "Itgam")
  low_genes <- c("Sulf2", "Angptl2", "Sirt4", "Sirt3", "Nnmt", "Sirt5", "Bcl2l2", "Nmnat1", "Nampt", "Parp6", "Igfbp2", "Parp3")

  # Criteria based on Study 2
  wechter_genes <- wechter_df[wechter_df$direction == "UP",]
  wechter_genes <- wechter_genes$gene

  # Criteria based on Study 3
  senmayo_genes <- senmayo_df[senmayo_df$Classification == "Intercellular signal molecule" & senmayo_df$State == "Secreted", ]
  senmayo_genes <- senmayo_genes$`Gene(murine)`
  
  # Score the resulting clusters
  cluster_scores <- sapply(1:k, function(nclust) {
    score <- 0
    
    # Retrieve the genes in the current cluster
    node_indexes <- which(kmeans_result$cluster == nclust)
    node_counts <- count_df[node_indexes,]
    
    # Check for genes that match each data set
    count_high_genes <- node_counts[node_counts$...1 %in% high_genes,]
    count_wechter_genes <- node_counts[node_counts$...1 %in% wechter_genes,]
    count_senmayo_genes <- node_counts[node_counts$...1 %in% senmayo_genes,]
    
    # Increment count for each match
    score <- score + nrow(count_high_genes)
    score <- score + nrow(count_wechter_genes)
    score <- score + nrow(count_senmayo_genes)
    
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
    
    if(nrow(count_wechter_genes) > 0) {
      wechter_genes_in_old <- count_wechter_genes[, old_cells]
      wecther_genes_in_young <- count_wechter_genes[, old_cells]
      
      wechter_genes_in_old_avg <- rowMeans(wechter_genes_in_old)
      wechter_genes_in_young_avg <- rowMeans(wechter_genes_in_young)
      
      score <- score + sum(wechter_genes_in_old_avg > wechter_genes_in_young_avg) 
    }
    
    if(nrow(count_senmayo_genes) > 0) {
      senmayo_genes_in_old <- count_senmayo_genes[, old_cells]
      senmayo_genes_in_young <- count_senmayo_genes[, young_cells]
      
      senmayo_genes_in_old_avg <- rowMeans(senmayo_genes_in_old)
      senmayo_genes_in_young_avg <- rowMeans(senmayo_genes_in_young)
      
      score <- score + sum(senmayo_genes_in_old_avg > senmayo_genes_in_young_avg)
    }
    
    # Final score
    return (score)
  })
  
  # Retrieves the cluster(s) with the highest score
  snc_clusters <- which(cluster_scores == max(cluster_scores))
  
  # Record likelihood scores
  scores_df <- data.frame(cell_ID=cell_ids)
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
  snc_cells <- scores_df[rowMeans(scores_df[,-1]) > 0.95,]$cell_ID
  
  # Record cells with high likelihood to text file
  write.csv(data.frame(cell_ID=snc_cells), output_file, row.names=FALSE, quote=FALSE)
  
  # Retrieve genes in SnC clusters for feature selection
  snc_genes <- count_df[kmeans_result$cluster %in% snc_clusters, ][["...1"]]
  
  # Return SnC genes and scores
  return(list(snc_genes, rowMeans(scores_df[,-1])))
}
