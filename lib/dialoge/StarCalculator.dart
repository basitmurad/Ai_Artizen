class StarCalculator {
  /// Calculates stars based on the ratio of correct answers to total.
  ///
  /// - 3 stars: 90% or higher
  /// - 2 stars: 70% or higher
  /// - 1 star: 50% or higher
  /// - 0 stars: below 50%
  static int calculateStars(int correct, int total) {
    if (total <= 0) return 0; // Avoid division by zero
    double percentage = correct / total;

    if (percentage >= 0.9) return 3;
    if (percentage >= 0.7) return 2;
    if (percentage >= 0.5) return 1;
    return 0;
  }
}
