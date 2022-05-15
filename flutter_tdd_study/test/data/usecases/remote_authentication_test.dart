import 'package:faker/faker.dart';
import 'package:flutter_tdd_study/data/http/http.dart';
import 'package:flutter_tdd_study/data/usecases/usecases.dart';
import 'package:flutter_tdd_study/domain/helpers/helpers.dart';
import 'package:flutter_tdd_study/domain/usecases/usecases.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  HttpClientSpy httpClient;
  String url;
  RemoteAuthentication sut;
  AuthenticationParams params;

  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    sut = RemoteAuthentication(httpClient: httpClient, url: url);
    params = AuthenticationParams(
        email: faker.internet.email(), secret: faker.internet.password());
  });

  test('Should call HttpCliente with correct values', () async {
    final accessToken = faker.guid.guid();
    when(
      httpClient.request(
        url: anyNamed("url"),
        method: anyNamed("method"),
        body: anyNamed("body"),
      ),
    ).thenAnswer((realInvocation) async => {
          'accessToken': accessToken,
          'name': faker.person.name(),
        });
    final params = AuthenticationParams(
        email: faker.internet.email(), secret: faker.internet.password());
    await sut.auth(params);

    verify(httpClient.request(
      url: url,
      method: 'post',
      body: {'email': params.email, 'password': params.secret},
    ));
  });

  test('Should throw UnexpexctedError if HttpClient return 400', () async {
    when(
      httpClient.request(
        url: anyNamed("url"),
        method: anyNamed("method"),
        body: anyNamed("body"),
      ),
    ).thenThrow(HttpError.badRequest);

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpexctedError if HttpClient return 404', () async {
    when(
      httpClient.request(
        url: anyNamed("url"),
        method: anyNamed("method"),
        body: anyNamed("body"),
      ),
    ).thenThrow(HttpError.notFound);

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpexctedError if HttpClient return 500', () async {
    when(
      httpClient.request(
        url: anyNamed("url"),
        method: anyNamed("method"),
        body: anyNamed("body"),
      ),
    ).thenThrow(HttpError.serverError);

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw invalidCedentialsError if HttpClient return 401',
      () async {
    when(
      httpClient.request(
        url: anyNamed("url"),
        method: anyNamed("method"),
        body: anyNamed("body"),
      ),
    ).thenThrow(HttpError.unauthorised);

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.invalidCredentails));
  });

  test('Should return an Account if HttpClient return 200', () async {
    final accessToken = faker.guid.guid();
    when(
      httpClient.request(
        url: anyNamed("url"),
        method: anyNamed("method"),
        body: anyNamed("body"),
      ),
    ).thenAnswer((realInvocation) async => {
          'accessToken': accessToken,
          'name': faker.person.name(),
        });

    final account = await sut.auth(params);

    expect(
      account.token,
      accessToken,
    );
  });

  test(
      'Should throw UnexpectedError if HttpCllient return 200 with invalid data',
      () async {
    when(
      httpClient.request(
        url: anyNamed("url"),
        method: anyNamed("method"),
        body: anyNamed("body"),
      ),
    ).thenAnswer((realInvocation) async => {
          'invalid_key': 'invalid_value',
        });

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });
}
