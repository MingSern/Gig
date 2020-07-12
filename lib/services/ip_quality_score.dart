import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class IpQualityScore {
  static final String baseUrl = "https://www.ipqualityscore.com/api/json/email";
  static final String key = "K4zOuM0sPUBDPk0g7198UvxK3Mm6XVuP";

  static Future<Response> call(String email) async {
    var response = await http.get("$baseUrl/$key/$email");
    print(response.body);
    return response;
  }
}
