import '../../domain/entities/entities.dart';
import '../http/http.dart';

class RemoteAccounttModel {
  final String accessToken;

  RemoteAccounttModel(this.accessToken);

  factory RemoteAccounttModel.fromJson(Map json) {
    if (!json.containsKey("accessToken")) {
      throw HttpError.invalidData;
    }
    return RemoteAccounttModel(json["accessToken"]);
  }

  AccountEntity toEntity() => AccountEntity(accessToken);
}
