import 'dart:convert';

import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';

class HttpAdapter {
  final Client? client;

  HttpAdapter({required this.client});

  Future<void> request({
    required String url,
    required String method,
    Map? body,
  }) async {
    final headers = {
      'content-type': 'application/json',
      'accept': 'application/json',
    };
    await client?.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(body),
    );
  }
}

class ClientSpy extends Mock implements Client {}

void main() {
  ClientSpy? client;
  HttpAdapter? sut;
  String? url;

  setUp(() {
    client = ClientSpy();
    sut = HttpAdapter(client: client ?? ClientSpy());
    url = faker.internet.httpUrl();
  });
  group('post', () {
    test('Should call post with correct values', () async {
      await sut?.request(
        url: url ?? '',
        method: 'post',
        body: {
          'any_key': 'any_value',
        },
      );

      verify(
        client?.post(
          Uri.parse(url ?? ''),
          headers: {
            'content-type': 'application/json',
            'accept': 'application/json',
          },
          body: '{"any_key":"any_value"}',
        ),
      );
    });
  });
}
