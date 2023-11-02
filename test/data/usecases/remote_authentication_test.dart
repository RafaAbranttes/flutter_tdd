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

  Map mockValidData() => {
        'accessToken': faker.guid.guid(),
        'name': faker.person.name(),
      };

  PostExpectation mockRequest() => when(
        httpClient?.request(
          url: anyNamed('url').toString(),
          method: anyNamed('method').toString(),
          body: anyNamed('body'),
        ),
      );

  void mockHttpData(Map data) {
    mockRequest().thenAnswer(
      (_) async => data,
    );
  }

  void mockHttpError(HttpError error) {
    mockRequest().thenThrow(
      error,
    );
  }

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
    mockHttpData(mockValidData());
  });

  test("Should call HttpClient with correct values", () async {
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
    mockHttpError(HttpError.badRequest);
    final future = sut?.auth(
      authenticationParams: params!,
    );

    expect(future, throwsA(DomainError.unexpected));
  });

  test("Should throw Invalid if HttpCliente returns 401", () async {
    mockHttpError(HttpError.unauthorized);
    final future = sut?.auth(
      authenticationParams: params!,
    );

    expect(future, throwsA(DomainError.invalidCredentials));
  });

  test("Should return an Account if HttpCliente returns 200", () async {
    final validData = mockValidData();
    mockHttpData(validData);
    final account = await sut?.auth(
      authenticationParams: params!,
    );

    expect(account?.token, validData['accessToken']);
  });

  test("Should throw Invalid if HttpCliente returns 404", () async {
    mockHttpError(HttpError.notFound);
    final future = sut?.auth(
      authenticationParams: params!,
    );

    expect(future, throwsA(DomainError.badRequest));
  });

  test("Should throw UnexpectedError if HttpCliente returns 500", () async {
    mockHttpError(HttpError.serverError);
    final future = sut?.auth(
      authenticationParams: params!,
    );

    expect(future, throwsA(DomainError.unexpected));
  });

  test(
      "Should throw UnexpectedError if HttpClient returns 200 with invalid data",
      () async {
    mockHttpData(
      {
        'invalid_key': 'invalid_value',
      },
    );
    final future = sut?.auth(
      authenticationParams: params!,
    );

    expect(future, throwsA(DomainError.unexpected));
  });
}
