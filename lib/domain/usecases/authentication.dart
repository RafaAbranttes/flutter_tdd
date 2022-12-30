import '../entities/entities.dart';

abstract class Authenticaction {
  Future<AccountEntity> auth({
    required String email,
    required String password,
  });
}
