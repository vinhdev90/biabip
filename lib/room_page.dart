import 'package:bia_bip/model/room_model.dart';
import 'package:bia_bip/room_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PlayPage extends StatefulWidget {
  // final String? name;

  const PlayPage({Key? key}) : super(key: key);

  @override
  State<PlayPage> createState() => _PlayPageState();
}

class _PlayPageState extends State<PlayPage> with TickerProviderStateMixin {
  var index = 0;
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
  );
  late TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller.forward();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final roomController = Get.put(RoomController());
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () async {
                await roomController.getTableInfo();
              },
              icon: const Icon(Icons.refresh)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.history)),
          IconButton(
              onPressed: () {
                roomController.showQrCode(context);
              },
              icon: const Icon(Icons.qr_code)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() => Center(
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: const Color(0xff8aaae5)),
                    child: Text(
                      'Phòng ${roomController.tableData.value.name}',
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                  ),
                )),
            const SizedBox(height: 8),
            Obx(
              () => _itemRow(roomController.tableData.value.player![0], () {
                roomController.showBottomChange(context,
                    roomController.tableData.value.player?[0].id ?? "");
              }),
            ),
            const Text('Danh sách người chơi'),
            Expanded(
              child: Obx(
                () => roomController.tableData.value.player == null
                    ? const SizedBox()
                    : ListView.builder(
                        shrinkWrap: true,
                        itemBuilder: (context, index) => _itemRow(
                            roomController.tableData.value.player![index + 1],
                            () {
                          roomController.showBottomChange(
                              context,
                              roomController
                                      .tableData.value.player?[index + 1].id ??
                                  "");
                        }),
                        itemCount:
                            roomController.tableData.value.player!.length - 1,
                      ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _itemRow(Players player, Function() onChange) {
    return InkWell(
      onTap: () {
        Get.find<RoomController>().showHistoryByUser(context, player.id!);
      },
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Text(
                  player.id == "Chicken" ? "Gà" : player.id!,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
              Expanded(
                flex: 3,
                child: Center(
                  child: IntrinsicWidth(
                    child: Container(
                      height: 40,
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      constraints:
                          const BoxConstraints(maxWidth: 100, minWidth: 40),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: parseColor(player.chips),
                          border: Border.all(
                              color: player.chips == 0
                                  ? Colors.black
                                  : Colors.transparent)),
                      child: Center(
                          child: Text('${player.chips}',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: parseTextColor(player.chips)))),
                    ),
                  ),
                ),
              ),
              Obx(() => Get.find<RoomController>().playerId.value == player.id!
                  ? const Expanded(flex: 1, child: SizedBox())
                  : Expanded(
                      flex: 1,
                      child: ElevatedButton(
                          onPressed: onChange,
                          child: const Icon(
                            Icons.currency_exchange,
                            size: 20,
                          )),
                    ))
            ],
          ),
          const SizedBox(height: 8)
        ],
      ),
    );
  }

  Color parseColor(dynamic number) {
    int data = 0;
    if (number.runtimeType == String) {
      data = int.parse(number);
    } else {
      data = number;
    }
    if (data == 0) {
      return Colors.white;
    } else if (data < 0) {
      return Colors.red.shade100;
    } else {
      return Colors.greenAccent.shade100;
    }
    return Colors.white;
  }

  Color parseTextColor(dynamic number) {
    int data = 0;
    if (number.runtimeType == String) {
      data = int.parse(number);
    } else {
      data = number;
    }
    if (data == 0) {
      return Colors.black;
    } else if (data < 0) {
      return Colors.red;
    } else {
      return Colors.green;
    }
    return Colors.white;
  }
}
