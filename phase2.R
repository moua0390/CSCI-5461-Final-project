# Supervised learning classifier — K-Nearest Neighbors

library(class)

set.seed(54612024)

supervised_snc_classifier <- function(train, test, k=5, output_file="phase2_predictions.txt") {
  # Retrieve SnC scores from training data
  #train_scores <- rowMeans(train[,-1])

  # Remove non-numeric columns
  train_filtered <- Filter(is.numeric, train)
  test_filtered <- Filter(is.numeric, test)

  # Perform K-Nearest Neighbors classification
  score <- knn(train_filtered, test_filtered, train_scores, k)

  # Append test scores to the test data set
  test_scored <- cbind(test, score)

  return (test_scored)
}
