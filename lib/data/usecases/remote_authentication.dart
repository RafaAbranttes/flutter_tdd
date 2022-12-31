import 'package:flutter_tdd_study/domain/entities/entities.dart';

import '../../domain/usecases/usecases.dart';
import '../http/http.dart';

class RemoteAuthentication {
  final HttpClient httpClient;
  final String url;

  RemoteAuthentication({
    required this.httpClient,
    required this.url,
  });

  Future<void> auth({
    required AuthenticationParams authenticationParams,
  }) async {
    final body =
        RemoteAuthenticationParams.fromDomain(authenticationParams).toMap();
    await httpClient.request(
      url: url,
      method: 'post',
      body: body,
    );
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
          AuthenticationParams authenticationParams) =>
      RemoteAuthenticationParams(
        email: authenticationParams.email,
        password: authenticationParams.password,
      );

  Map toMap() => {
        "email": email,
        "password": password,
      };
}
