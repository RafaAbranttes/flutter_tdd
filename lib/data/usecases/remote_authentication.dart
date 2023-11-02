import 'package:flutter_tdd_study/data/http/http.dart';
import 'package:flutter_tdd_study/domain/domain.dart';

class RemoteAuthentication {
  final HttpClient httpClient;
  final String url;

  RemoteAuthentication({
    required this.httpClient,
    required this.url,
  });

  Future<AccountEntity> auth({
    required AuthenticationParams authenticationParams,
  }) async {
    final body =
        RemoteAuthenticationParams.fromDomain(authenticationParams).toMap();
    try {
     final httpResponse = await httpClient.request(
        url: url,
        method: 'post',
        body: body,
      );
      return AccountEntity.fromJson(httpResponse);
    } on HttpError catch (error) {
      throw error == HttpError.unauthorized
          ? DomainError.invalidCredentials
          : DomainError.unexpected;
    }
  }
}

class RemoteAuthenticationParams {
  final String email;
  final String password;

  RemoteAuthenticationParams({
    required this.email,
    required this.password,
  });

  factory RemoteAuthenticationParams.fromDomain(
    AuthenticationParams authenticationParams,
  ) =>
      RemoteAuthenticationParams(
        email: authenticationParams.email,
        password: authenticationParams.password,
      );

  Map toMap() => {
        "email": email,
        "password": password,
      };
}
