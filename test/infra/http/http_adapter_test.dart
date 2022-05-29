import 'package:faker/faker.dart';
import 'package:flutter_tdd_study/data/http/http.dart';
import 'package:flutter_tdd_study/infra/htpp/htpp.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class ClientSpy extends Mock implements Client {}

void main() {
  HttpAdapter sut;
  ClientSpy client;
  String url;

  setUp(() {
    client = ClientSpy();
    sut = HttpAdapter(client);
    url = faker.internet.httpUrl();
    when(client.post(any, headers: anyNamed("headers"), body: anyNamed("body")))
        .thenAnswer((_) async => Response('{"any_key":"any_value"}', 200));
  });

  group('post', () {
    PostExpectation mockRequest() => when(
        client.post(any, headers: anyNamed("headers"), body: anyNamed("body")));

    void mockResponse(
      int statusCode, {
      String body = '{"any_key":"any_value"}',
    }) {
      mockRequest().thenAnswer((_) async => Response(body, statusCode));
    }

    setUp(() {
      mockResponse(200);
    });

    test(
      'should call post without body',
      () async {
        await sut.request(
          url: url,
          method: 'post',
        );

        verify(
          client.post(
            any,
            headers: anyNamed('headers'),
          ),
        );
      },
    );
    test(
      'should call post with correct values',
      () async {
        await sut.request(
          url: url,
          method: 'post',
          body: {
            "any_key": "any_value",
          },
        );

        verify(
          client.post(
            Uri.parse(url),
            headers: {
              'content-type': 'application/json',
              'accept': 'application/json'
            },
            body: '{"any_key":"any_value"}',
          ),
        );
      },
    );

    test(
      'should return data if post returns 200',
      () async {
        final response = await sut.request(
          url: url,
          method: 'post',
        );

        expect(response, {"any_key": "any_value"});
      },
    );

    test(
      'should return null if post returns 200 with no data',
      () async {
        mockResponse(200, body: '');
        final response = await sut.request(
          url: url,
          method: 'post',
        );

        expect(response, null);
      },
    );

    test(
      'should return null if post returns 204',
      () async {
        mockResponse(204, body: '');
        final response = await sut.request(
          url: url,
          method: 'post',
        );

        expect(response, null);
      },
    );

    test(
      'should return null if post returns 204 with data',
      () async {
        mockResponse(204);
        final response = await sut.request(
          url: url,
          method: 'post',
        );

        expect(response, null);
      },
    );

    test(
      'should return BadRequestError if post returns 400',
      () async {
        mockResponse(400);

        final future = sut.request(
          url: url,
          method: 'post',
        );

        expect(future, throwsA(HttpError.badRequest));
      },
    );

    test(
      'should return BadRequestError if post returns 400 with data',
      () async {
        mockResponse(400, body: '');

        final future = sut.request(
          url: url,
          method: 'post',
        );

        expect(future, throwsA(HttpError.badRequest));
      },
    );
  });
}
