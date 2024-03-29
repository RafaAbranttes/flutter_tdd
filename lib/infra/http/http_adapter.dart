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
    Response? response = Response('', 500);
    try {
      if (method == 'post') {
        response = await client?.post(
          Uri.parse(url),
          headers: headers,
          body: jsonEncode(body),
        );
      }
    } catch (error) {
      throw HttpError.serverError;
    }
    return _handleResponse(response);
  }

  Map? _handleResponse(Response? response) {
    if (response?.statusCode == 200) {
      return response?.body == ""
          ? null
          : jsonDecode(response?.body ?? "") as Map<dynamic, dynamic>?;
    } else if (response?.statusCode == 204) {
      return null;
    } else if (response?.statusCode == 400) {
      throw HttpError.badRequest;
    } else if (response?.statusCode == 401) {
      throw HttpError.unauthorized;
    } else if (response?.statusCode == 403) {
      throw HttpError.forbidden;
    } else if (response?.statusCode == 404) {
      throw HttpError.notFound;
    } else {
      throw HttpError.serverError;
    }
  }
}
