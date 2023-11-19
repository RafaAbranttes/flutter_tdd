import 'package:flutter_tdd_study/data/http/http.dart';
import 'package:flutter_tdd_study/data/models/models.dart';
import 'package:flutter_tdd_study/domain/domain.dart';

class RemoteAuthentication implements Authentication{
  final HttpClient httpClient;
  final String url;

  RemoteAuthentication({
    required this.httpClient,
    required this.url,
  });

  @override
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
      return RemoteAccountModel.fromJson(httpResponse ?? <dynamic, dynamic>{}).toEntity();
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
