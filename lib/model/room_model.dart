import 'package:bia_bip/model/tranfer_log_model.dart';

class TableModel {
  String? id;
  String? name;
  Map<String, dynamic>? players;
  Map<String, dynamic>? history;
  List<Players>? player;
  List<TransferLogModel>? logs;

  TableModel({this.id, this.name, this.players, this.logs});

  TableModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    players = json['players'];
    history = json['history'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}

class Players {
  dynamic chips;
  String? id;

  Players({this.chips, this.id});

  Players.fromJson(Map<String, dynamic> json) {
    chips = json['chips'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['chips'] = chips;
    data['id'] = id;
    return data;
  }
}
