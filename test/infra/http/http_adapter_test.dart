import 'dart:convert';

import 'package:faker/faker.dart';
import 'package:flutter_tdd_study/data/http/http.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';

class HttpAdapter implements HttpClient {
  final Client? client;

  HttpAdapter({required this.client});

  @override
  Future<Map> request({
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

    return jsonDecode(response?.body ?? "") as Map;
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
  group(
    'post',
    () {
      test(
        'Should call post with correct values',
        () async {
          when(
            client?.post(
              Uri.parse(url ?? ''),
              body: anyNamed('body'),
              headers: anyNamed('headers'),
            ),
          ).thenAnswer(
            (_) async => Response(
              '{"any_key":"any_value"}',
              200,
            ),
          );

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
        },
      );

      test(
        'Should return data if post returns 200',
        () async {
          when(
            client?.post(
              Uri.parse(url ?? ''),
              headers: anyNamed('headers'),
            ),
          ).thenAnswer(
            (_) async => Response(
              '{"any_key":"any_value"}',
              200,
            ),
          );

          final response = await sut?.request(
            url: url ?? '',
            method: 'post',
          );

          expect(
            response,
            {
              'any_key': 'any_value',
            },
          );
        },
      );
    },
  );
}
