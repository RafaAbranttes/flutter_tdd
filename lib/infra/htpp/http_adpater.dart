import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_tdd_study/data/http/http.dart';
import 'package:http/http.dart';

class HttpAdapter implements HttpClient {
  final Client client;

  HttpAdapter(this.client);

  @override
  Future<Map> request({
    @required String url,
    @required String method,
    Map body,
  }) async {
    final headers = {
      'content-type': 'application/json',
      'accept': 'application/json'
    };
    final jsonBody = body != null ? jsonEncode(body) : null;
    final response =
        await client.post(Uri.parse(url), headers: headers, body: jsonBody);
    return _handleResponse(response);
  }

  Map _handleResponse(Response response) {
    return response.statusCode == 200
        ? response.body.isEmpty
            ? null
            : json.decode(response.body)
        : response.statusCode == 204
            ? null
            : throw HttpError.badRequest;
  }
}
