import 'dart:convert';

typedef ErrorCallback = void Function(ErrorResult err);
typedef ReadRfidCallback = void Function(List<RfidData> datas);
typedef ConnectionStatusCallback = void Function(ReaderConnectionStatus status);

class ZebraEngineEventHandler {
  ReadRfidCallback readRfidCallback;
  ConnectionStatusCallback connectionStatusCallback;
  ErrorCallback errorCallback;
  ZebraEngineEventHandler({
    required this.readRfidCallback,
    required this.connectionStatusCallback,
    required this.errorCallback,
  });

  // ignore: public_member_api_docs
  void process(String eventName, Map<String, dynamic> map) {
    switch (eventName) {
      case 'ReadRfid':
        List<dynamic> rfidDatas = map["datas"];
        List<RfidData> list = [];
        for (var i = 0; i < rfidDatas.length; i++) {
          list.add(RfidData.fromMap(Map<String, dynamic>.from(rfidDatas[i])));
        }
        readRfidCallback.call(list);
        break;
      case 'Error':
        var ss = ErrorResult.fromMap(map);
        errorCallback.call(ss);
        break;
      case 'ConnectionStatus':
        ReaderConnectionStatus status =
            ReaderConnectionStatus.values[map["status"] as int];
        connectionStatusCallback.call(status);
        break;
    }
  }
}

enum ReaderConnectionStatus {
  ///not connected
  UnConnection,

  ///connection complete
  ConnectionRealy,

  ///connection error
  ConnectionError,
}

class RfidData {
  String tagID;

  int antennaID;
  int peakRSSI;

  // public String tagDetails;

  // ACCESS_OPERATION_STATUS opStatus;

  int relativeDistance;

  int count = 0;

  String memoryBankData;

  String lockData;

  int allocatedSize;
  RfidData({
    required this.tagID,
    required this.antennaID,
    required this.peakRSSI,
    required this.relativeDistance,
    required this.count,
    required this.memoryBankData,
    required this.lockData,
    required this.allocatedSize,
  });

  Map<String, dynamic> toMap() {
    return {
      'tagID': tagID,
      'antennaID': antennaID,
      'peakRSSI': peakRSSI,
      'relativeDistance': relativeDistance,
      'count': count,
      'memoryBankData': memoryBankData,
      'lockData': lockData,
      'allocatedSize': allocatedSize,
    };
  }

  factory RfidData.fromMap(Map<String, dynamic> map) {
    return RfidData(
      tagID: map['tagID'] ?? '',
      antennaID: map['antennaID']?.toInt() ?? 0,
      peakRSSI: map['peakRSSI']?.toInt() ?? 0,
      relativeDistance: map['relativeDistance']?.toInt() ?? 0,
      count: map['count']?.toInt() ?? 0,
      memoryBankData: map['memoryBankData'] ?? '',
      lockData: map['lockData'] ?? '',
      allocatedSize: map['allocatedSize']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory RfidData.fromJson(String source) =>
      RfidData.fromMap(json.decode(source));
}

class ErrorResult {
  int code = -1;
  String errorMessage = "";
  ErrorResult({
    required this.code,
    required this.errorMessage,
  });

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'errorMessage': errorMessage,
    };
  }

  factory ErrorResult.fromMap(Map<String, dynamic> map) {
    return ErrorResult(
      code: map['code']?.toInt() ?? 0,
      errorMessage: map['errorMessage'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ErrorResult.fromJson(String source) =>
      ErrorResult.fromMap(json.decode(source));
}
