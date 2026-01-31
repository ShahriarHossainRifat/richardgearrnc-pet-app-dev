// lib/services/network_caller.dart
import 'package:http/http.dart' as http;

class NetworkCaller {
  static Future<http.Response> get({
    required String url,
    required String token,
  }) async {
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'accept': '*/*',
      },
    );
    return response;
  }
}