import 'package:Gig/enum/enum.dart';

class Checker {
  static JobStatus getJobStatus(String status) {
    return JobStatus.values.firstWhere((e) => e.toString() == status);
  }

  static UserType getUserType(String type) {
    return UserType.values.firstWhere((e) => e.toString() == type);
  }
}
