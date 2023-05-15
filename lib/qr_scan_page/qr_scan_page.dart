import 'package:bia_bip/controller/global_controller.dart';
import 'package:bia_bip/room_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../api_controller/api_controller.dart';
import '../room_page.dart';
import '../user_pref.dart';

class QrScanPage extends StatefulWidget {
  const QrScanPage({Key? key}) : super(key: key);

  @override
  State<QrScanPage> createState() => _QrScanPageState();
}

class _QrScanPageState extends State<QrScanPage> {
  Barcode? result;
  QRViewController? qrController;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  final TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    qrController?.resumeCamera();
    return _buildQrView(context);
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 350.0
        : 500.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.white,
          borderRadius: 10,
          borderLength: 10,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      qrController = controller;
    });
    controller.scannedDataStream.listen((scanData) async {
      await successAndGoToPlay(scanData);
    });
  }

  Future<void> successAndGoToPlay(Barcode scanData) async {
    final controller = Get.put(RoomController());
    // print(scanData.code);
    if (scanData.code != null &&
        scanData.code!.isNotEmpty &&
        scanData.code!.contains("-")) {
      controller.roomId.value = scanData.code!.replaceAll("biabip.cc/", '');
      var info = UserPref().getUser();
      var data = await ApiDioController.getTableInfo(
          scanData.code!.replaceAll("biabip.cc/", ''));
      if (data == null) return;
      qrController?.pauseCamera();
      Get.back();
      await ApiDioController.joinTable(
          info.playerId ?? "", scanData.code!.replaceAll("biabip.cc/", ''));
      Get.find<GlobalController>()
          .addTableToHistory(scanData.code!.replaceAll("biabip.cc/", ''));
      await controller.getTableInfo();
      Get.to(() => const PlayPage());
    }
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    qrController?.dispose();
    super.dispose();
  }
}
