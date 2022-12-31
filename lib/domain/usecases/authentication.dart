import '../entities/entities.dart';

abstract class Authenticaction {
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
