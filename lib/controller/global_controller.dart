import 'package:bia_bip/model/user_information.dart';
import 'package:bia_bip/user_pref.dart';
import 'package:get/get.dart';

class GlobalController extends GetxController {
  var info = UserInformation().obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  void addTableToHistory(String tableId) {
    info.value.listRoomJoined ??= [];
    for (var item in info.value.listRoomJoined!) {
      if (item == tableId) {
        return;
      }
    }
    info.value.listRoomJoined?.add(tableId);
    UserPref().setUser(info.value);
  }
}
