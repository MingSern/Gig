import 'dart:math';

import 'package:Gig/lists/categories.dart';

class Generator {
  static final random = new Random();

  static Map generateAccountData() {
    var emails = [
      "sv883",
      "xmvo4",
      "0aejs",
      "b0w8e",
      "7cvhs",
      "5jsjh",
      "cgwh0",
      "c3qy8",
      "z19d8",
      "4njvl",
      "r5afa",
      "r9twi",
      "r6752",
      "3i7ug",
      "54d9r",
      "o7hdi",
      "0l6ba",
      "y51jh",
      "3jjp5",
      "54js6",
      "4xnfg",
      "ce6jz",
      "kca3g",
      "uo5pt",
      "aujam",
      "nj7gu",
      "u39fh",
      "ekwvl",
      "pxujr",
      "gxsq2",
      "vjnb4",
      "524od",
      "7xo2k",
      "3ct85",
      "5psw1",
      "zno5b",
      "g9dzc",
      "6chkd",
      "m6nsl",
      "vpl9p",
      "o000x",
      "738y1",
      "8le3n",
      "up2f4",
      "22skq",
      "emva4",
      "qoniy",
      "tixcc",
      "8edqx",
      "vs9bf",
      "kfsgz",
      "rmjr6",
      "klv3f",
      "hl4dg",
      "n7ei3",
      "tii10",
      "w3jqj",
      "h1tgi",
      "lucb3",
      "jp7rl",
      "c545f",
      "vmj3m",
      "ausvd",
      "g3nke",
      "7eyd5",
      "jihy5",
      "giyj9",
      "xn3ne",
      "ade1o",
      "r5943",
      "r7v4p",
      "39nc7",
      "z1ryv",
      "qrcoj",
      "023ho",
      "vmjbj",
      "86cmo",
      "z5zrp",
      "st8zg",
      "l9qyf",
      "1rqd8",
      "jhtk9",
      "ojk2e",
      "owm6n",
      "ze675",
      "zkfgc",
      "nh44i",
      "7bj8g",
      "vdgir",
      "wjm8q",
      "ixyve",
      "d6btj",
      "3fvwm",
      "qvxgf",
      "rh13z",
      "nogce",
      "gbs8q",
      "hqkcc",
      "be5b0",
      "zis0b",
    ];

    var age = List.generate(33, (number) {
      return (number + 18).toString();
    });
    var gender = ["Male", "Female"];
    var name = emails[random.nextInt(emails.length)];
    var number = random.nextInt(100);

    var data = {
      "email": name + number.toString() + "@gmail.com",
      "password": "111111",
      "fullname": name,
      "businessName": name + name,
      "gender": gender[random.nextInt(gender.length)],
      "age": age[random.nextInt(age.length)],
    };

    return data;
  }

  static Map generateJobData() {
    var locations = [
      [
        "Budiman Business Park, Jln Budiman, Taman Desa Baru, 43200 Cheras 9 Miles, Selangor",
        "3.029930",
        "101.773430",
      ],
      [
        "No3, Jalan Temengung 5/9, Bandar Mahkota Cheras, 43200 Kajang, Selangor",
        "3.052500",
        "101.787220",
      ],
      [
        "26 & 27, Jalan Mendaling, Bandar Kajang, 43000 Kajang, Selangor",
        "2.873160",
        "101.816180",
      ],
      [
        "41-G, Jalan Temenggung 21/9, Bandar Mahkota Cheras, 43200 Cheras, Selangor",
        "3.052080",
        "101.787567",
      ],
      [
        "37, Jalan Manis 4, Taman Bukit Segar, 56100 Cheras, Wilayah Persekutuan Kuala Lumpur",
        "3.089410",
        "101.742930",
      ],
      [
        "26G, Jalan SL1/11, Bandar Sungai Long, Jalan Cheras, 43300 Kajang, Selangor, 43300 Selangor",
        "3.047110",
        "101.797060",
      ],
      [
        "32G, Jalan Dataran Cheras 6, Dataran Perniagaan Cheras, 43200 Cheras, Selangor",
        "3.074610",
        "101.772370",
      ],
      [
        "No. 69, Jalan Dataran Cheras 4, Dataran Perniagaan Cheras, Balakong, 43200 Cheras, Selangor",
        "3.040970",
        "101.770110",
      ],
      [
        "Jalan Temenggung 21/9 G-20-20L & G-21-21L, Ground Floor BMC mall, Bandar Mahkota Cheras, 43200 Cheras, Selangor",
        "3.011462",
        "101.478807",
      ],
      [
        "No. 46 & 48, Jalan Temenggung 1/9, Bandar Mahkota Cheras, 43200 Cheras, Selangor",
        "3.053750",
        "101.787930",
      ],
      [
        "18-1, Jalan Manis 4, Taman Bukit Segar, 56100 Cheras, Wilayah Persekutuan Kuala Lumpur",
        "3.088660",
        "101.743710",
      ],
      [
        "168, Jalan 7, Pekan Batu 9 Cheras, 43200 Cheras, Selangor",
        "3.069190",
        "101.770800",
      ],
      [
        "Jalan Residence 1, 25, Jalan Mahkota, Bandar Mahkota Cheras, 43200 Cheras, Selangor",
        "3.052020",
        "101.789200",
      ],
      [
        "6, Jalan Temenggung 29/9, Bandar Mahkota Cheras, 43200 Kajang, Selangor",
        "3.052460",
        "101.786980",
      ],
      [
        "No. 9 & 11, Mahkota Square, Jalan Temenggung 23/9, Bandar Mahkota Cheras, 43200 Cheras, Selangor",
        "3.051930",
        "101.789070",
      ],
      [
        "25, Jalan Kasturi 3, Taman Kasturi, 43200 Cheras, Selangor",
        "3.038990",
        "101.768370",
      ],
    ];
    var ageCategory = ["18-20", "21-30", "31-40", "Any"];
    var genderCategory = ["Male", "Female", "Any"];

    var index = [0, 1, 2, 3, 4, 5, 6, 7, 8];
    // var index = [0, 6, 7, 8];

    var randomJob = jobCategories[index[random.nextInt(index.length)]];
    var category = randomJob["category"];
    var workPositions = randomJob["workPosition"];
    var responsibilities = randomJob["responsibilities"];
    var requirements = randomJob["requirements"];
    var randomWorkPosition = workPositions[random.nextInt(workPositions.length)];

    responsibilities = responsibilities.where((line) {
      return random.nextInt(100) <= 20;
    }).toList();

    requirements = requirements.where((line) {
      return random.nextInt(100) <= 20;
    }).toList();

    var desciption =
        "Responsibilities:\n" + responsibilities.join("\n") + "\n\nRequirements:\n" + requirements.join("\n");

    var data = {
      "workPosition": randomWorkPosition,
      "wages": (random.nextInt(30) + 1).toString(),
      "location": locations[random.nextInt(locations.length)],
      "description": desciption,
      "category": category,
      "age": ageCategory[random.nextInt(ageCategory.length)],
      "gender": genderCategory[random.nextInt(genderCategory.length)],
    };

    return data;
  }

  static String getImageUrl() {
    List<String> imageUrls = [
      "https://tinyurl.com/vhafedq",
      "https://tinyurl.com/wby7c6p",
      "https://tinyurl.com/sgkkooq",
      "https://tinyurl.com/scdhlob",
      "https://tinyurl.com/vtoae8a",
      "https://tinyurl.com/ueuycw7",
      "https://tinyurl.com/wer4nyp",
      "https://tinyurl.com/to6adnl",
      "https://tinyurl.com/tzwpsyp",
      "https://tinyurl.com/tgzxkxb",
      "https://tinyurl.com/utt78f8",
      "https://tinyurl.com/qmxp6d2",
      "https://tinyurl.com/rzpamuq",
      "https://tinyurl.com/w9v88oe",
      "https://tinyurl.com/qvlvpea",
    ];

    return imageUrls[random.nextInt(imageUrls.length)];
  }
}
