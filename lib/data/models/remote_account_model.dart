import 'package:flutter_tdd_study/data/http/http.dart';
import 'package:flutter_tdd_study/domain/domain.dart';

class RemoteAccountModel {
  final String accessToken;

  RemoteAccountModel({required this.accessToken});

  factory RemoteAccountModel.fromJson(Map json) {
    if(!json.containsKey('accessToken')){
      throw HttpError.invalidData;
    }
    return RemoteAccountModel(
        accessToken: json['accessToken'].toString(),
      );
  }

  AccountEntity toEntity () => AccountEntity(accessToken);
}
