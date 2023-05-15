import 'dart:async';

import 'package:bia_bip/api_controller/api_controller.dart';
import 'package:bia_bip/model/room_model.dart';
import 'package:bia_bip/model/tranfer_log_model.dart';
import 'package:bia_bip/user_pref.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';

class RoomController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController;
  var roomId = "".obs;
  var playerId = "".obs;
  var tableData = TableModel().obs;
  var amount = "".obs;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);
    playerId.value = UserPref().getUser().playerId ?? "";
    Timer.periodic(const Duration(minutes: 1), (timer) async {
      await getTableInfo();
    });
  }

  Future<void> getTableInfo() async {
    final data = await ApiDioController.getTableInfo(roomId.value);
    if (data == null) return;
    tableData.value = data;
    tableData.refresh();
  }

  Future<void> showQrCode(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            width: Get.width,
            height: Get.width,
            child: Center(
              child: QrImage(
                data: "$roomId",
                version: QrVersions.auto,
                size: 200.0,
              ),
            ),
          ),
        );
      },
    );
  }

  void showBottomChange(BuildContext context, String id) {
    final TextEditingController textEditingController = TextEditingController();
    textEditingController.text = "";
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          height: 200 + MediaQuery.of(context).viewInsets.bottom + 24,
          padding: EdgeInsets.fromLTRB(
              24, 24, 24, 24 + MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('Chuyển cho $id',
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 16)),
              TextFormField(
                onChanged: (val) {
                  amount.value = val;
                },
                // controller: textEditingController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    labelText: "Nhập số tiền", border: OutlineInputBorder()),
              ),
              ElevatedButton(
                child: const Text('Chuyển tiền'),
                onPressed: () async {
                  if (amount.isEmpty) return;
                  final data = await ApiDioController.tranferChip(
                      playerId.value,
                      roomId.value,
                      id,
                      int.parse(amount.value));
                  if (data != null) {
                    Navigator.pop(context);
                    EasyLoading.showToast("Chuyển thành công");
                    await getTableInfo();
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> showHistoryByUser(BuildContext context, String playerId) {
    var receiverLog = getLogReceiveById(playerId).reversed.toList();
    var transferLog = getLogTransferById(playerId).reversed.toList();
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            width: Get.width - 48,
            height: Get.height / 2,
            child: Column(
              children: [
                TabBar(controller: tabController, tabs: const [
                  Text('Chuyển',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  Text('Nhận',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ]),
                const SizedBox(height: 24),
                Expanded(
                    child: TabBarView(controller: tabController, children: [
                  ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: (context, index) => Column(
                      children: [
                        logWidget(transferLog[index], false,
                            transferLog[index].fromPlayerId!),
                        const SizedBox(height: 8)
                      ],
                    ),
                    itemCount: transferLog.length,
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: (context, index) => Column(
                      children: [
                        logWidget(receiverLog[index], true,
                            receiverLog[index].toPlayerId!),
                        const SizedBox(height: 8)
                      ],
                    ),
                    itemCount: receiverLog.length,
                  ),
                ]))
              ],
            ),
          ),
        );
      },
    );
  }

  Widget logWidget(TransferLogModel log, bool isReceive, String playerId) {
    var millis = log.timestamp!;
    var dt = DateTime.fromMillisecondsSinceEpoch(millis);
    var date = DateFormat('MM/dd, hh:mm a').format(dt);
    TextStyle style = const TextStyle(
        fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black);

    if (isReceive) {
      String track = "";
      if (log.toPlayer!.id! == playerId) {
        track =
            "[${log.toPlayer?.beforeBalance} => ${log.toPlayer?.afterBalance}] ↓";
      }
      return Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              RichText(
                text: TextSpan(
                  text: '${log.toPlayerId}'.toUpperCase(),
                  style: style,
                  children: <TextSpan>[
                    TextSpan(
                        text: ' nhận',
                        style: style.copyWith(color: Colors.grey)),
                    TextSpan(
                        text: ' ${log.amount}'.toUpperCase(),
                        style: style.copyWith(
                            color: Colors.green, fontWeight: FontWeight.bold)),
                    TextSpan(
                        text: ' từ', style: style.copyWith(color: Colors.grey)),
                    TextSpan(text: ' ${log.fromPlayerId}'.toUpperCase(), style: style),
                    TextSpan(
                        text: ' \n\n($date)\n',
                        style: style.copyWith(color: Colors.grey)),
                    TextSpan(
                        text: ' \nBiến động: $track',
                        style: style.copyWith(color: Colors.green)),
                  ],
                ),
              ),
            ],
          ));
    } else {
      String track = "";
      if (log.fromPlayer!.id! == playerId) {
        track =
            "[${log.fromPlayer?.beforeBalance} -> ${log.fromPlayer?.afterBalance}] ↑";
      }
      return Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              RichText(
                text: TextSpan(
                  text: '${log.fromPlayerId}'.toUpperCase(),
                  style: style,
                  children: <TextSpan>[
                    TextSpan(
                        text: ' chuyển',
                        style: style.copyWith(color: Colors.grey)),
                    TextSpan(
                        text: ' ${log.amount}',
                        style: style.copyWith(
                            color: Colors.red.shade500,
                            fontWeight: FontWeight.bold)),
                    TextSpan(
                        text: ' tới',
                        style: style.copyWith(color: Colors.grey)),
                    TextSpan(text: ' ${log.toPlayerId}'.toUpperCase(), style: style),
                    TextSpan(
                        text: ' \n\n($date)\n',
                        style: style.copyWith(color: Colors.grey)),
                    TextSpan(
                        text: ' \nBiến động: $track',
                        style: style.copyWith(color: Colors.red.shade500)),
                  ],
                ),
              ),
            ],
          ));
    }
  }

  List<TransferLogModel> getLogReceiveById(String playerId) {
    List<TransferLogModel> logs = [];
    if (tableData.value.logs == null) return [];
    for (var i in tableData.value.logs!) {
      if (i.toPlayerId == playerId) {
        logs.add(i);
      }
    }
    return logs;
  }

  List<TransferLogModel> getLogTransferById(String playerId) {
    List<TransferLogModel> logs = [];
    if (tableData.value.logs == null) return [];
    for (var i in tableData.value.logs!) {
      if (i.fromPlayerId == playerId) {
        logs.add(i);
      }
    }
    return logs;
  }
}
