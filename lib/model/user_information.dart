import 'package:bia_bip/model/room_model.dart';

class UserInformation {
  String? playerId;
  bool? logon;
  List<dynamic>? listRoomJoined;

  UserInformation({
    this.playerId,
    this.logon,
    this.listRoomJoined,
  });

  UserInformation.fromJson(Map<String, dynamic> json) {
    playerId = json['playerId'];
    logon = json['logon'] ?? false;
    listRoomJoined = json['listRoomJoined'] ?? [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['playerId'] = playerId;
    data['logon'] = logon;
    data['listRoomJoined'] = listRoomJoined;
    return data;
  }
}
