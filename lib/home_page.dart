import 'package:bia_bip/home_page/home_controller.dart';
import 'package:bia_bip/model/user_information.dart';
import 'package:bia_bip/user_pref.dart';
import 'package:bia_bip/wel_come_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller/global_controller.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int indexTab = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: indexTab == 0
            ? SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      SizedBox(
                        width: Get.width,
                        height: 60,
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Xin chào'),
                                  Row(
                                    children: [
                                      Container(
                                        constraints: BoxConstraints(
                                            maxWidth: Get.width / 3),
                                        child: Obx(
                                          () => Text(
                                              Get.find<GlobalController>()
                                                  .info
                                                  .value
                                                  .playerId!,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black,
                                                  fontSize: 20)),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 120,
                              child: ElevatedButton(
                                  onPressed: () {
                                    UserPref().setUser(UserInformation(
                                        logon: false,
                                        playerId: '',
                                        listRoomJoined: []));
                                    controller.info.value = UserInformation();
                                    Get.delete<HomeController>();
                                    Get.offAll(() => const WelcomePage());
                                  },
                                  child: const Text('Đăng xuất')),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 32.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  _itemCreate(
                                      Icons.table_restaurant, 'Tạo bàn mới',
                                      onTap: () async {
                                    controller.createRoom(
                                        controller.info.value.playerId ?? "");
                                  }),
                                  _itemCreate(Icons.qr_code, 'Quét mã QR',
                                      onTap: () {
                                    controller.showQrScanner(context);
                                  }),
                                ],
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Form(
                                key: controller.formKey,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(24.0),
                                      child: TextFormField(
                                        onChanged: (val) {
                                          controller.roomId.value = val;
                                        },
                                        decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                            labelText: "Nhập ID phòng"),
                                        validator: (val) {
                                          if (val == null || val.isEmpty) {
                                            return 'Vui lòng nhập tên phòng';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                            child: IconButton(
                                                onPressed: () {
                                                  controller.gotoRoom(
                                                      name: controller
                                                          .roomId.value);
                                                },
                                                icon: const Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(Icons.input),
                                                    SizedBox(width: 8),
                                                    Text('Vào phòng')
                                                  ],
                                                ))),
                                        // Expanded(
                                        //   child: IconButton(
                                        //       onPressed: () {
                                        //         if (_formKey.currentState!
                                        //             .validate()) {}
                                        //       },
                                        //       icon: Row(
                                        //         mainAxisAlignment:
                                        //             MainAxisAlignment.center,
                                        //         children: const [
                                        //           Icon(Icons.visibility),
                                        //           SizedBox(width: 8),
                                        //           Text('Xem phòng')
                                        //         ],
                                        //       )),
                                        // ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Obx(
                        () => controller.info.value.listRoomJoined == null ||
                                controller.info.value.listRoomJoined!.isEmpty
                            ? const SizedBox()
                            : ElevatedButton(
                                onPressed: () {
                                  controller.gotoRoom(
                                      name: controller
                                          .info.value.listRoomJoined!.last);
                                },
                                child:
                                    const Text('Vào lại phòng chơi gần nhất')),
                      ),
                      const SizedBox(height: 8)
                    ],
                  ),
                ),
              )
            : SafeArea(
                child: Container(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(width: 40),
                          const Text(
                            'Lịch sử (Gần nhất)',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600),
                          ),
                          IconButton(
                              onPressed: () {
                                controller.info.value = UserPref().getUser();
                                controller.info.refresh();
                              },
                              icon: Icon(Icons.refresh))
                        ],
                      ),
                      const SizedBox(height: 24),
                      ListView.builder(
                          shrinkWrap: true,
                          reverse: true,
                          itemBuilder: (context, index) => Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      controller.gotoRoom(
                                          name: controller.info.value
                                              .listRoomJoined![index]);
                                    },
                                    borderRadius: BorderRadius.circular(8),
                                    child: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border.all(
                                              color: Colors.black
                                                  .withOpacity(0.2))),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16, horizontal: 8),
                                      child: Text(
                                          'Bàn có ID : ${controller.info.value.listRoomJoined![index]}'),
                                    ),
                                  ),
                                  const SizedBox(height: 8)
                                ],
                              ),
                          itemCount:
                              controller.info.value.listRoomJoined?.length)
                    ],
                  ),
                ),
              ),
        bottomNavigationBar: BottomNavigationBar(
          onTap: (index) {
            setState(() {
              indexTab = index;
            });
          },
          currentIndex: indexTab,
          selectedItemColor: Colors.blue,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.history), label: 'Lịch sử'),
          ],
        ),
      ),
    );
  }

  Widget _itemCreate(IconData icon, String title, {required Function() onTap}) {
    return Material(
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300)),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                SizedBox(
                  width: 80,
                  height: 80,
                  child: Icon(
                    icon,
                    size: 40,
                  ),
                ),
                Text(title)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
