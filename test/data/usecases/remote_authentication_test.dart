import 'package:faker/faker.dart';
import 'package:flutter_tdd_study/data/http/http.dart';
import 'package:flutter_tdd_study/data/usecases/usercases.dart';
import 'package:flutter_tdd_study/domain/usecases/usecases.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  HttpClientSpy? httpClient;
  String? url;
  RemoteAuthentication? sut;

  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    sut = RemoteAuthentication(
      httpClient: httpClient ?? HttpClientSpy(),
      url: url ?? "",
    );
  });

  test("Should call HttpClient with correct values", () async {
    final params = AuthenticationParams(
      email: faker.internet.email(),
      password: faker.internet.password(),
    );
    await sut?.auth(
      authenticationParams: params,
    );

    verify(httpClient?.request(
      url: url ?? "",
      method: 'post',
      body: {"email": params.email, "password": params.password},
    ));
  });
}
