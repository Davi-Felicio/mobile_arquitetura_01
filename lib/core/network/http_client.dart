import 'dart:convert';
import 'package:http/http.dart' as http;

class HttpResponse {
  final dynamic data;

  HttpResponse(this.data);
}

class AppHttpClient {
  Future<HttpResponse> get(String url) async {
    final response = await http.get(Uri.parse(url));
    return HttpResponse(jsonDecode(response.body));
  }
}
