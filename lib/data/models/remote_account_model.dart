import 'package:flutter_tdd_study/domain/domain.dart';

class RemoteAccountModel {
  final String accessToken;

  RemoteAccountModel({required this.accessToken});

  factory RemoteAccountModel.fromJson(Map json) => RemoteAccountModel(
        accessToken: json['accessToken'].toString(),
      );

  AccountEntity toEntity () => AccountEntity(accessToken);
}
