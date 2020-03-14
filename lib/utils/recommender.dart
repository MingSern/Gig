class Recommender {
  static hybridRecommender(dynamic jobs) {}

  static contentBasedFiltering(dynamic jobs) {}

  static collaborativeFiltering(dynamic jobs) {
    List<dynamic> ratedJob = [];

    for (var job in jobs) {
      double wagesRate = job.preferedWages - job.job["wages"];
    }

    // wages
    // description
    // category
    // work position
  }
}
