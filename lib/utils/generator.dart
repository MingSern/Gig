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

    var name = emails[random.nextInt(emails.length)];
    var num = random.nextInt(100);

    var data = {
      "email": name + num.toString() + "@gmail.com",
      "password": "111111",
      "fullname": name,
      "businessName": name + name,
    };

    return data;
  }

  static Map generateJobData() {
    var jobs = [
      "Sales representative",
      "Sales manager",
      "Salesperson",
      "Salesman",
      "Saleswoman",
      "Cashier",
      "Seller",
      "Merchant",
      "Distributor",
      "Advertising agent",
      "Grocer",
      "Greengrocer",
      "Baker",
      "Butcher",
      "Florist",
      "Artist",
      "Painter",
      "Sculptor",
      "Architect",
      "Composer",
      "Conductor",
      "Musician",
      "Pianist",
      "Violinist",
      "Guitarist",
      "Drummer",
      "Player",
      "Singer",
      "Designer",
      "Fashion designer",
      "Dress designer",
      "Interior designer",
      "Furniture designer",
      "Graphic designer",
    ];

    var locations = [
      "Hialeah",
      "Lock Haven",
      "Ocala",
      "Morrilton",
      "Windham",
      "Lincoln",
      "Pauls Valley",
      "Denton",
      "Moorhead",
      "Wahiawa",
      "Kampong Wan Chik",
      "Kampung Beluru",
      "Kampung Kuncau",
      "Lubok Nibong",
      "Kampung Ganun",
      "Kampong Kepala Tomang",
      "Aloi Lubok",
      "Rumah Ingka",
      "Kampong Banggol Damar",
      "Kampung Kaparingan",
      "Kampung Perdak",
      "Kampung Pandang Kela",
      "Sembulan",
      "Kampong Batu Thirty-seven",
      "Kampong Tok Jamal",
      "Kampong Asam Kumbang",
      "Kampong Sungai Atun",
      "Kampong Palau Belachan",
      "Kampung Padang Che Nudin",
      "Kuala Gramma",
      "Rumah Chadun",
      "Kampung Bukit Katong",
      "Kampung Siong",
      "Kampong Buloh Semerah",
      "Kampung Rid",
    ];

    var data = {
      "workPosition": jobs[random.nextInt(jobs.length)],
      "wages": random.nextInt(30).toString(),
      "location": locations[random.nextInt(locations.length)],
      "description": "I want more detailed information.",
      "category": categories[random.nextInt(categories.length)],
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
    ];

    return imageUrls[random.nextInt(imageUrls.length)];
  }
}
