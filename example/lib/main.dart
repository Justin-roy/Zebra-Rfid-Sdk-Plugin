import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zebra_rfid_sdk_plugin/zebra_event_handler.dart';
import 'package:zebra_rfid_sdk_plugin/zebra_rfid_sdk_plugin.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? _platformVersion = 'Unknown';
  // int power = 200;

  // double get powerValue => power / 1000;

  // final powerMin = 0;
  // final powerMax = 270;
  // set powerValue(double value) {
  //   power = (value * 1000).toInt();
  //   print('powerValue $power');
  //   ZebraRfidSdkPlugin.setPower(power);
  // }

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Map<String?, RfidData> rfidDatas = {};
  ReaderConnectionStatus connectionStatus = ReaderConnectionStatus.UnConnection;
  addDatas(List<RfidData> datas) async {
    for (var item in datas) {
      var data = rfidDatas[item.tagID];
      if (data != null) {
        if (data.count == null) data.count = 0;
        data.count = data.count + 1;
        data.peakRSSI = item.peakRSSI;
        data.relativeDistance = item.relativeDistance;
      } else
        rfidDatas.addAll({item.tagID: item});
    }
    setState(() {});
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String? platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await ZebraRfidSdkPlugin.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: Text('Status  ${connectionStatus.index}'),
      ),
      body: Center(
          child: Column(
        children: [
          Text('Running on: $_platformVersion\n'),
          Text('count:${rfidDatas.length.toString()}'),
          const SizedBox(height: 20),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            ElevatedButton(
              onPressed: () async {
                ZebraRfidSdkPlugin.setEventHandler(ZebraEngineEventHandler(
                  readRfidCallback: (datas) async {
                    addDatas(datas);
                  },
                  errorCallback: (err) {
                    ZebraRfidSdkPlugin.toast(err.errorMessage);
                  },
                  connectionStatusCallback: (status) {
                    setState(() {
                      connectionStatus = status;
                    });
                  },
                ));
                ZebraRfidSdkPlugin.connect();
              },
              child: const Text("read"),
            ),
            ElevatedButton(
              onPressed: () async {
                setState(() {
                  rfidDatas = {};
                });
              },
              child: const Text("clear"),
            ),
            ElevatedButton(
              onPressed: () async {
                ZebraRfidSdkPlugin.disconnect();
              },
              child: const Text("stop"),
            ),
          ]),
          Expanded(
              child: Scrollbar(
            child: ListView.builder(
              itemBuilder: (context, index) {
                var key = rfidDatas.keys.toList()[index];
                return ListTile(title: Text(rfidDatas[key]?.tagID ?? 'null'));
              },
              itemCount: rfidDatas.length,
            ),
          ))
        ],
      )),
    ));
  }
}
