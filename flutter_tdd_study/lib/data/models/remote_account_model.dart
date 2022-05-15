import 'package:flutter_tdd_study/domain/entities/account_entity.dart';

class RemoteAccounttModel {
  final String accessToken;

  RemoteAccounttModel(this.accessToken);

  factory RemoteAccounttModel.fromJson(Map json) =>
      RemoteAccounttModel(json["accessToken"]);

  AccountEntity toEntity() => AccountEntity(accessToken);
}
