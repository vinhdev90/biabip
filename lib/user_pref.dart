import 'package:bia_bip/model/room_model.dart';
import 'package:get_storage/get_storage.dart';

import 'model/user_information.dart';

final userBox = () => GetStorage();

class UserPref {
  void call() {
    userBox.call().initStorage;
  }

  dynamic setValueInt(String key, int value) {
    return 0.val(key, getBox: userBox).val = value;
  }

  String setValue(String key, String value) {
    return ''.val(key, getBox: userBox).val = value;
  }

  dynamic getValueInt(String key) {
    return (-1).val(key, getBox: userBox).val;
  }

  dynamic getValue(String key) {
    return ''.val(key, getBox: userBox).val;
  }

  void setUser(UserInformation user) {
    ''.val('playerId', getBox: userBox).val = user.playerId ?? "";
    false.val('logon', getBox: userBox).val = user.logon ?? false;
    [].val('listRoomJoined', getBox: userBox).val =
        user.listRoomJoined ?? [];
  }

  UserInformation getUser() {
    final String playerId = ''.val('playerId', getBox: userBox).val;
    final bool logon = false.val('logon', getBox: userBox).val;
    final data = [].val('listRoomJoined', getBox: userBox).val;

    return UserInformation(
      playerId: playerId,
      logon: logon,
      listRoomJoined: data,
    );
  }
}
