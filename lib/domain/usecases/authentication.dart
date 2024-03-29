import 'package:flutter_tdd_study/domain/entities/entities.dart';

abstract class Authentication {
  Future<AccountEntity> auth({
    required AuthenticationParams authenticationParams,
  });
}

class AuthenticationParams {
  final String email;
  final String password;

  AuthenticationParams({
    required this.email,
    required this.password,
  });

}
