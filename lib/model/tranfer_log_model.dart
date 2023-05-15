class TransferLogModel {
  int? amount;
  String? fromPlayerId;
  Balance? fromPlayer;
  String? id;
  int? timestamp;
  String? toPlayerId;
  Balance? toPlayer;

  TransferLogModel(
      {this.amount,
      this.fromPlayer,
      this.fromPlayerId,
      this.id,
      this.timestamp,
      this.toPlayer,
      this.toPlayerId});

  TransferLogModel.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    fromPlayerId = json['fromPlayerId'];
    fromPlayer = json['fromPlayer'] != null
        ? Balance.fromJson(json['fromPlayer'])
        : null;
    id = json['id'];
    timestamp = json['timestamp'];
    toPlayerId = json['toPlayerId'];
    toPlayer =
        json['toPlayer'] != null ? Balance.fromJson(json['toPlayer']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['amount'] = amount;
    data['fromPlayerId'] = fromPlayerId;
    if (fromPlayer != null) {
      data['fromPlayer'] = fromPlayer!.toJson();
    }
    data['id'] = id;
    data['timestamp'] = timestamp;
    data['toPlayerId'] = toPlayerId;
    if (toPlayer != null) {
      data['fromPlayer'] = toPlayer!.toJson();
    }
    return data;
  }
}

class Balance {
  int? afterBalance;
  int? beforeBalance;
  String? id;

  Balance({this.afterBalance, this.beforeBalance, this.id});

  Balance.fromJson(Map<String, dynamic> json) {
    afterBalance = json['afterBalance'];
    beforeBalance = json['beforeBalance'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['afterBalance'] = afterBalance;
    data['beforeBalance'] = beforeBalance;
    data['id'] = id;
    return data;
  }
}
