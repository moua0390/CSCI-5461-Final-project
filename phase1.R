# Unsupervised learning classifier — K-Means clustering

install.packages("useful")
library(useful)

set.seed(54612024)

unsupervised_snc_classifier <- function(count_df) {
  #count_df <- read.csv("Integrated_scaled_counts_release.txt", header=TRUE) 

  num_clusters = 30

  kmeans_result <- kmeans(count_df[-1, -1], num_clusters)
  plot(kmeans_result)
  print(kmeans_result)

  # Append scores to the data set
  scored_df <- cbind(count_df, kmeans_result)
  
  return (scored_df)
}
