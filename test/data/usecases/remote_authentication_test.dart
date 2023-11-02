import 'package:faker/faker.dart';
import 'package:flutter_tdd_study/data/http/http.dart';
import 'package:flutter_tdd_study/data/usecases/usecases.dart';
import 'package:flutter_tdd_study/domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  HttpClientSpy? httpClient;
  String? url;
  RemoteAuthentication? sut;
  AuthenticationParams? params;

  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    sut = RemoteAuthentication(
      httpClient: httpClient ?? HttpClientSpy(),
      url: url!,
    );
    params = AuthenticationParams(
      email: faker.internet.email(),
      password: faker.internet.password(),
    );
  });

  test("Should call HttpClient with correct values", () async {
    when(
      httpClient?.request(
        url: anyNamed('url').toString(),
        method: anyNamed('method').toString(),
        body: anyNamed('body'),
      ),
    ).thenAnswer(
      (_) async => {
        'accessToken': faker.guid.guid(),
        'name': faker.person.name(),
      },
    );

    await sut?.auth(
      authenticationParams: params!,
    );

    verify(
      httpClient?.request(
        url: url ?? "",
        method: 'post',
        body: {"email": params?.email, "password": params?.password},
      ),
    );
  });

  test("Should throw UnexpectedError if HttpCliente returns 400", () async {
    when(
      httpClient?.request(
        url: anyNamed('url') ?? "",
        method: anyNamed('method') ?? "",
        body: anyNamed('body'),
      ),
    ).thenThrow(HttpError.badRequest);
    final future = sut?.auth(
      authenticationParams: params!,
    );

    expect(future, throwsA(DomainError.unexpected));
  });

  test("Should throw Invalid if HttpCliente returns 401", () async {
    when(
      httpClient?.request(
        url: anyNamed('url').toString(),
        method: anyNamed('method').toString(),
        body: anyNamed('body'),
      ),
    ).thenThrow(HttpError.unauthorized);
    final future = sut?.auth(
      authenticationParams: params!,
    );

    expect(future, throwsA(DomainError.invalidCredentials));
  });

  test("Should return an Account if HttpCliente returns 200", () async {
    final accessToken = faker.guid.guid();
    when(
      httpClient?.request(
        url: anyNamed('url').toString(),
        method: anyNamed('method').toString(),
        body: anyNamed('body'),
      ),
    ).thenAnswer(
      (_) async => {
        'accessToken': accessToken,
        'name': faker.person.name(),
      },
    );
    final account = await sut?.auth(
      authenticationParams: params!,
    );

    expect(account?.token, accessToken);
  });

  test("Should throw Invalid if HttpCliente returns 404", () async {
    when(
      httpClient?.request(
        url: anyNamed('url').toString(),
        method: anyNamed('method').toString(),
        body: anyNamed('body'),
      ),
    ).thenThrow(HttpError.notFound);
    final future = sut?.auth(
      authenticationParams: params!,
    );

    expect(future, throwsA(DomainError.badRequest));
  });

  test("Should throw UnexpectedError if HttpCliente returns 500", () async {
    when(
      httpClient?.request(
        url: anyNamed('url').toString(),
        method: anyNamed('method').toString(),
        body: anyNamed('body'),
      ),
    ).thenThrow(HttpError.serverError);
    final future = sut?.auth(
      authenticationParams: params!,
    );

    expect(future, throwsA(DomainError.unexpected));
  });

  test(
      "Should throw UnexpectedError if HttpClient returns 200 with invalid data",
      () async {
    when(
      httpClient?.request(
        url: anyNamed('url').toString(),
        method: anyNamed('method').toString(),
        body: anyNamed('body'),
      ),
    ).thenAnswer(
      (_) async => {
        'invalid_key': 'invalid_value',
      },
    );
    final future = sut?.auth(
      authenticationParams: params!,
    );

    expect(future, throwsA(DomainError.unexpected));
  });
}
