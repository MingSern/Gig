class Recommender {
  static hybridRecommender(dynamic jobs) {}

  static contentBasedFiltering(dynamic jobs) {
    List<dynamic> ratedJob = [];

    for (var job in jobs) {
      for (var anotherJob in jobs) {
        if (job != anotherJob) {
          double wagesRate = double.parse(job["wages"]) - double.parse(anotherJob["wages"]);
          
        }
      }
    }

    // wages
    // description
    // category
    // work position
  }

  static collaborativeFiltering(dynamic jobs) {}
}
