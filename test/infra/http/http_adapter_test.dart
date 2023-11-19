import 'package:faker/faker.dart';
import 'package:flutter_tdd_study/data/http/http_error.dart';
import 'package:flutter_tdd_study/infra/http/http.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';

class ClientSpy extends Mock implements Client {}

void main() {
  late ClientSpy client;
  late HttpAdapter sut;
  late String url;

  setUp(() {
    client = ClientSpy();
    sut = HttpAdapter(client: client);
    url = faker.internet.httpUrl();
  });

  group('shared', () {
    test(
      'Should throw serverError if invalid method is provided',
      () async {
        final future = sut.request(
          url: url,
          method: 'invalid_method',
        );

        expect(
          future,
          throwsA(HttpError.serverError),
        );
      },
    );
  });

  group(
    'post',
    () {
      When mockRequest() => when(
            () => client.post(
              Uri.parse(url),
              body: any(named: 'body'),
              headers: any(named: 'headers'),
            ),
          );
      void mockResponse({
        required int statusCode,
        String body = '{"any_key":"any_value"}',
      }) {
        mockRequest().thenAnswer(
          (_) async => Response(
            body,
            statusCode,
          ),
        );
      }

      void mockError() {
        mockRequest().thenThrow(
          Exception(),
        );
      }

      setUp(() {
        mockResponse(statusCode: 200);
      });
      test(
        'Should call post with correct values',
        () async {
          await sut.request(
            url: url,
            method: 'post',
            body: {
              'any_key': 'any_value',
            },
          );

          verify(
            () => client.post(
              Uri.parse(url),
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
          final response = await sut.request(
            url: url,
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

      test(
        'Should return null if post returns 200 with no data',
        () async {
          mockResponse(statusCode: 200, body: '');

          final response = await sut.request(
            url: url,
            method: 'post',
          );

          expect(
            response,
            null,
          );
        },
      );

      test(
        'Should return null if post returns 204',
        () async {
          mockResponse(statusCode: 204, body: '');

          final response = await sut.request(
            url: url,
            method: 'post',
          );

          expect(
            response,
            null,
          );
        },
      );

      test(
        'Should return null if post returns 204 with data',
        () async {
          mockResponse(statusCode: 204);

          final response = await sut.request(
            url: url,
            method: 'post',
          );

          expect(
            response,
            null,
          );
        },
      );

      test(
        'Should return BadRequestError if post returns 400 with body empty',
        () async {
          mockResponse(statusCode: 400, body: '');

          final future = sut.request(
            url: url,
            method: 'post',
          );

          expect(
            future,
            throwsA(HttpError.badRequest),
          );
        },
      );

      test(
        'Should return BadRequestError if post returns 400',
        () async {
          mockResponse(statusCode: 400);

          final future = sut.request(
            url: url,
            method: 'post',
          );

          expect(
            future,
            throwsA(HttpError.badRequest),
          );
        },
      );

      test(
        'Should return unauthorizedError if post returns 401',
        () async {
          mockResponse(statusCode: 401);

          final future = sut.request(
            url: url,
            method: 'post',
          );

          expect(
            future,
            throwsA(HttpError.unauthorized),
          );
        },
      );

      test(
        'Should return ForbiddenError if post returns 403',
        () async {
          mockResponse(statusCode: 403);

          final future = sut.request(
            url: url,
            method: 'post',
          );

          expect(
            future,
            throwsA(HttpError.forbidden),
          );
        },
      );

      test(
        'Should return notFoundError if post returns 404',
        () async {
          mockResponse(statusCode: 404);

          final future = sut.request(
            url: url,
            method: 'post',
          );

          expect(
            future,
            throwsA(HttpError.notFound),
          );
        },
      );

      test(
        'Should return ServerError if post returns 500',
        () async {
          mockResponse(statusCode: 500);

          final future = sut.request(
            url: url,
            method: 'post',
          );

          expect(
            future,
            throwsA(HttpError.serverError),
          );
        },
      );

      test(
        'Should return ServerError if post throws',
        () async {
          mockError();

          final future = sut.request(
            url: url,
            method: 'post',
          );

          expect(
            future,
            throwsA(HttpError.serverError),
          );
        },
      );
    },
  );
}
