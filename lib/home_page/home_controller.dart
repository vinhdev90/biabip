import 'dart:math';

import 'package:bia_bip/controller/global_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../api_controller/api_controller.dart';
import '../model/user_information.dart';
import '../qr_scan_page/qr_scan_page.dart';
import '../room_controller.dart';
import '../room_page.dart';
import '../user_pref.dart';

class HomeController extends GetxController {
  final TextEditingController nameController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  var info = UserInformation().obs;
  var indexTab = 0.obs;
  var roomId = ''.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    info.value = UserPref().getUser();
  }

  Future<void> gotoRoom({String? name}) async {
    EasyLoading.show(status: 'Đang vào phòng');
    final controller = Get.put(RoomController());
    Get.find<GlobalController>().addTableToHistory(name ?? "");
    controller.roomId.value = name ?? "";
    await ApiDioController.joinTable(
        Get.find<GlobalController>().info.value.playerId!, name!);
    await controller.getTableInfo();
    EasyLoading.dismiss();
    Get.to(() => const PlayPage());
  }

  Future<void> createRoom(String name) async {
    EasyLoading.show(status: 'Đang tạo bàn...');
    final data =
        await ApiDioController.createTable("Bip_${Random().nextInt(99)}");
    if (data != null) {
      Get.find<GlobalController>().addTableToHistory(data);
      final controller = Get.put(RoomController());
      controller.roomId.value = data;
      await ApiDioController.joinTable(
          Get.find<GlobalController>().info.value.playerId!, data);
      await controller.getTableInfo();
      EasyLoading.dismiss();
      Get.to(() => const PlayPage());
    } else {
      EasyLoading.dismiss();
    }
  }

  Future<void> showQrScanner(BuildContext context) {
    return showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return SizedBox(
              width: Get.width,
              height: Get.height - 80,
              child: const QrScanPage());
        });
  }

// Widget changeName(BuildContext context) {
//   return IntrinsicHeight(
//     child: Padding(
//       padding: EdgeInsets.fromLTRB(
//           24, 24, 24, 24 + MediaQuery.of(context).viewInsets.bottom),
//       child: Column(
//         children: [
//           Center(
//             child: TextFormField(
//               controller: nameController,
//               decoration: InputDecoration(
//                   labelText: "Nhập tên khác", border: OutlineInputBorder()),
//             ),
//           ),
//           ElevatedButton(
//               onPressed: () {
//                 if (nameController.text.isNotEmpty) {
//                   name.value = nameController.text;
//                   UserPref().setUser(
//                       UserInformation(logon: true, playerId: name.value));
//                   Get.back();
//                 }
//               },
//               child: Text("Đổi"))
//         ],
//       ),
//     ),
//   );
// }
}
