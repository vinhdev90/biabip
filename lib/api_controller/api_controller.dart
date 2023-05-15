import 'dart:convert';
import 'dart:io';

import 'package:bia_bip/model/room_model.dart';
import 'package:bia_bip/model/tranfer_log_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;

const int kDefaultTimeOut = 60 * 1000;

// @Deprecated('Use Api Provider instead')
class ApiDioController {
  static const _baseUrl =
      kReleaseMode ? 'https://biabip.ntbinh.me' : 'https://biabip.ntbinh.me';

  static BaseOptions options = BaseOptions(
    baseUrl: _baseUrl,
    connectTimeout: const Duration(seconds: 50),
    receiveTimeout: const Duration(seconds: 50),
  );

  // Contruction to use multiple project
  static Future<T?> getData<T>({
    required String url,
    required Dio dio,
    Map<String, dynamic>? query,
    required Function(dynamic) asModel,
  }) async {
    try {
      Response<Map<String, dynamic>> response = await dio.get(
        url,
        queryParameters: query,
      );
      if (response.data == null) return null;
      return asModel(response.data!);
    } on DioError catch (e) {
      debugPrint(e.response.toString());
      return null;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  static Future<T?> postMethods<T>({
    required String url,
    required Dio dio,
    dynamic body,
    required Function(Map<String, dynamic>) asModel,
    Function(String)? error,
  }) async {
    try {
      Response<Map<String, dynamic>> response = await dio.post(
        url,
        data: body,
      );
      print(response);
      if (response.data == null) return null;
      return asModel(response.data!);
    } on DioError catch (e) {
      debugPrint(e.response.toString());
      return null;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  static Future<TableModel?> getTableInfo(String tableId) async {
    TableModel? info;
    Dio dio = Dio(options);
    await getData<TableModel>(
      url: "/${ApiURL.tableUrl}/$tableId",
      dio: dio,
      asModel: (map) {
        var data = TableModel.fromJson(map);
        data.player = [];
        data.logs = [];
        if (data.players != null) {
          for (var i in data.players!.values.toList()) {
            data.player!.add(Players.fromJson(i));
          }
        }
        if (data.history != null) {
          for (var i in data.history!.values.toList()) {
            data.logs!.add(TransferLogModel.fromJson(i));
          }
        }
        return info = data;
      },
    );
    return info;
  }

  static Future<String?> createTable(String tableName) async {
    String? idTable;
    Dio dio = Dio(options);
    await postMethods<String>(
      url: "/${ApiURL.tableUrl}/$tableName",
      dio: dio,
      // query: {'id': userId},
      // metaCallback: (meta) {
      //   if (meta == null) return;
      // },
      asModel: (map) {
        return idTable = map['id'];
      },
    );
    return idTable;
  }

  static Future<String?> joinTable(String playerId, String tableId) async {
    String? idTable;
    Dio dio = Dio(options);
    await postMethods<String>(
      url: "/${ApiURL.tableUrl}/$tableId/players/$playerId",
      dio: dio,
      // query: {'id': userId},
      // metaCallback: (meta) {
      //   if (meta == null) return;
      // },
      asModel: (map) {
        return idTable = map['id'];
      },
    );
    return idTable;
  }

  static Future<String?> tranferChip(
      String playerId, String tableId, String toPlayerId, int amount) async {
    String? data;
    Dio dio = Dio(options);

    await postMethods<String>(
      url: "/${ApiURL.tableUrl}/$tableId/players/$playerId/transfer",
      dio: dio,
      body: {'toPlayerId': toPlayerId, "amount": amount},
      asModel: (map) {
        return data = map.toString();
      },
    );
    return data;
    ;
  }
}

class ApiURL {
  static const String baseUrl = "https://dev-api.truyen3k.com";

  // static const String baseUrl = "";
  static const String tableUrl = "tables";
}
