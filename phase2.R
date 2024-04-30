# Supervised learning classifier — K-Nearest Neighbors

library(class)

set.seed(54612024)

supervised_snc_classifier <- function(train, train_scores, test, k=30, output_file="phase2_predictions.txt") {
  # Transpose data in order to cluster by cell
  train_transpose <- t(train[,-1])
  test_transpose <- t(test[,-1])

  # Perform K-Nearest Neighbors classification
  score <- knn(train_transpose, test_transpose, train_scores, k)

  # Record test scores for each cell
  test_scored <- t(data.frame(score, row.names=rownames(test_transpose)))
  write.csv(test_scored, output_file, row.names=FALSE, quote=FALSE)

  return (test_scored)
}
