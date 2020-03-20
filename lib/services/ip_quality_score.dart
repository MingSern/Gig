import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class IpQualityScore {
  static final String baseUrl = "https://www.ipqualityscore.com/api/json/email";
  static final String key = "5KEowSNgLv4nULpVcNUDlHQzeJip3fVo";

  static Future<Response> call(String email) async {
    var response = await http.get("$baseUrl/$key/$email");

    return response;
  }
}
