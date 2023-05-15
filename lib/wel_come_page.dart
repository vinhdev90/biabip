import 'package:bia_bip/constant/image_paths.dart';
import 'package:bia_bip/controller/global_controller.dart';
import 'package:bia_bip/home_page.dart';
import 'package:bia_bip/home_page/home_controller.dart';
import 'package:bia_bip/model/user_information.dart';
import 'package:bia_bip/user_pref.dart';
import 'package:bia_bip/widget/change_lang.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final _formKey = GlobalKey<FormState>();
  var playerId = '';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const ChangeLanguage(),
                    SizedBox(
                      height: 120,
                      width: 120,
                      child: Image.asset(ImagePath.bipCC),
                    ),
                    const SizedBox(height: 40),
                    Expanded(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Nhập tên của bạn',
                          ),
                          // inputFormatters: [
                          //   LengthLimitingTextInputFormatter(2),
                          //   FilteringTextInputFormatter.allow(RegExp(r'(^3[6-9]{0,2}|4[0-2]{0,2})$')),
                          // ],
                          onChanged: (val) {
                            setState(() {
                              playerId = val;
                            });
                          },
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return 'Vui lòng nhập tên';
                            }
                            return null;
                          },
                        ),
                        Column(
                          children: [
                            SizedBox(
                              width: 160,
                              height: 40,
                              child: ElevatedButton(
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      var data = UserInformation(
                                          logon: true, playerId: playerId);
                                      UserPref().setUser(data);
                                      Get.find<GlobalController>().info.value =
                                          data;
                                      Get.find<GlobalController>()
                                          .info
                                          .refresh();
                                      Get.offAll(() => HomePage());
                                    }
                                  },
                                  child: const Text('Đăng nhập')),
                            ),
                            const SizedBox(height: 40),
                            const Text(
                              'From BỊP TEAM with 🖤',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            )
                          ],
                        )
                      ],
                    ))
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
