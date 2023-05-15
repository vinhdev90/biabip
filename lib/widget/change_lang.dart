import 'package:bia_bip/constant/image_paths.dart';
import 'package:flutter/material.dart';

class ChangeLanguage extends StatefulWidget {
  const ChangeLanguage({Key? key}) : super(key: key);

  @override
  State<ChangeLanguage> createState() => _ChangeLanguageState();
}

class _ChangeLanguageState extends State<ChangeLanguage> {
  bool isVn = true;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(
          width: 60,
          height: 40,
          child: IconButton(
              onPressed: () {
                setState(() {
                  isVn = !isVn;
                });
              },
              icon: isVn
                  ? Image.asset(ImagePath.vnFlag)
                  : Image.asset(ImagePath.enFlag)),
        )
      ],
    );
  }
}
