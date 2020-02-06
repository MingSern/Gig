class Time {
  static var monthMap = {
    "01": "Jan",
    "02": "Feb",
    "03": "Mar",
    "04": "Apr",
    "05": "May",
    "06": "Jun",
    "07": "Jul",
    "08": "Aug",
    "09": "Sep",
    "10": "Oct",
    "11": "Nov",
    "12": "Dec",
  };

  static getDateTime(var timestamp) {
    var createdAt = new DateTime.fromMicrosecondsSinceEpoch(timestamp * 1000);
    var diff = new DateTime.now().difference(createdAt);

    var timestampArray = createdAt.toString().split(" ");
    var dateArray = timestampArray[0].split("-");
    var timeArray = timestampArray[1].split(":");

    var year = dateArray[0].toString();
    var month = monthMap[dateArray[1]];
    var day = dateArray[2].toString();
    var date = "$day $month $year";

    var hourToInt = int.parse(timeArray[0]);
    var daytime = hourToInt < 12 ? "am" : "pm";
    var time = (hourToInt - 12).toString() + ":" + timeArray[1] + " " + daytime;

    if (diff.inDays == 1) {
      return "Yesterday";
    } else if (diff.inDays > 1) {
      return date;
    } else {
      return time;
    }
  }

  static String getTime(var timestamp) {
    var createdAt = new DateTime.fromMicrosecondsSinceEpoch(timestamp * 1000);

    var timestampArray = createdAt.toString().split(" ");
    var timeArray = timestampArray[1].split(":");

    var hourToInt = int.parse(timeArray[0]);
    var daytime = hourToInt < 12 ? "am" : "pm";
    var hour = hourToInt < 12 ? hourToInt : hourToInt - 12;
    var minutes = timeArray[1];
    var time = "$hour:$minutes $daytime";

    return time;
  }

  static String getDate(var timestamp) {
    var createdAt = new DateTime.fromMicrosecondsSinceEpoch(timestamp * 1000);

    var timestampArray = createdAt.toString().split(" ");
    var dateArray = timestampArray[0].split("-");

    var year = dateArray[0];
    var month = monthMap[dateArray[1]];
    var day = dateArray[2];
    var date = "$day $month $year";

    return date;
  }
}
