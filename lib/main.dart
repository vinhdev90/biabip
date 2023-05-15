import 'package:bia_bip/controller/global_controller.dart';
import 'package:bia_bip/user_pref.dart';
import 'package:bia_bip/wel_come_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'home_page.dart';
import 'home_page/home_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLogon = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initBase();
  }

  Future<void> initBase() async {
    final globalController = Get.put(GlobalController());
    var userPref = UserPref().getUser();
    globalController.info.value = userPref;
    print(userPref.toJson());
    var logonData = userPref.logon;
    if (logonData == null) return;
    setState(() {
      isLogon = logonData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'BiaBip.cc',
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
      ),
      home: isLogon ? HomePage() : const WelcomePage(),
      builder: EasyLoading.init(),
    );
  }
}
