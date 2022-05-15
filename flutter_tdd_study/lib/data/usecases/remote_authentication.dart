import 'package:flutter/material.dart';
import 'package:flutter_tdd_study/domain/entities/account_entity.dart';
import 'package:flutter_tdd_study/domain/helpers/helpers.dart';
import 'package:flutter_tdd_study/domain/usecases/usecases.dart';
import '../http/http.dart';
import '../models/models.dart';

class RemoteAuthentication {
  final HttpClient httpClient;
  final String url;

  RemoteAuthentication({
    @required this.httpClient,
    @required this.url,
  });

  Future<AccountEntity> auth(AuthenticationParams params) async {
    try {
      final httpReponse = await httpClient.request(
        url: url,
        method: 'post',
        body: RemoteAuthenticationParams.fromDomain(params).toJson(),
      );
      return RemoteAccounttModel.fromJson(httpReponse).toEntity();
    } on HttpError catch (error) {
      throw error == HttpError.unauthorised
          ? DomainError.invalidCredentails
          : DomainError.unexpected;
    }
  }
}

class RemoteAuthenticationParams {
  final String email;
  final String password;

  RemoteAuthenticationParams({
    @required this.email,
    @required this.password,
  });

  factory RemoteAuthenticationParams.fromDomain(AuthenticationParams entity) =>
      RemoteAuthenticationParams(
        email: entity.email,
        password: entity.secret,
      );

  Map toJson() => {'email': email, 'password': password};
}
