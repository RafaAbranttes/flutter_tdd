import 'dart:js_interop';

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

  test("Should throw UnexpectedError if HttpCliente returns 404", () async {
    when(
      httpClient?.request(
        url : anyNamed('url').toString(),
        method: anyNamed('method').toString(),
        body: anyNamed('body'),
      ),
    ).thenThrow(HttpError.notFound);
    final future = sut?.auth(
      authenticationParams: params!,
    );

    expect(future, throwsA(DomainError.unexpected));
  });
}
