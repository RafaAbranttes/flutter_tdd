import 'dart:convert';

import 'package:flutter_tdd_study/data/http/http.dart';
import 'package:http/http.dart';

class HttpAdapter implements HttpClient {
  final Client? client;

  HttpAdapter({required this.client});

  @override
  Future<Map?> request({
    required String url,
    required String method,
    Map? body,
  }) async {
    final headers = {
      'content-type': 'application/json',
      'accept': 'application/json',
    };
    final response = await client?.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(body),
    );
    return _handleResponse(response);
  }

  Map? _handleResponse(Response? response) {
    if (response?.statusCode == 200) {
      return response?.body == null
          ? null
          : jsonDecode(response?.body ?? "") as Map?;
    } else {
      return null;
    }
  }
}
