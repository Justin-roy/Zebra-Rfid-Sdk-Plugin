# Zebra Rfid SDK Plugin

## Steps to follow

```javascript
1. flutter pub add zebra_rfid_sdk_plugin
2. add folder to android
   -  android/RFIDAPI3Library
   -  copy content from here below link
Note:- (build.gradle and RFIDAPI3Library.arr and add this files to android/RFIDAPI3Library)
Like:- https://github.com/Justin-roy/Zebra-Rfid-Sdk-Plugin/tree/main/android/RFIDAPI3Library
3. In Setting.gradle add below lines.
   - include ':app',':RFIDAPI3Library'
   - project(":RFIDAPI3Library").projectDir = file("./RFIDAPI3Library")
4. Add below line to Android.xml
   - xmlns:tools="http://schemas.android.com/tools" (this will add under manifest tag)
   - tools:replace="android:label" (this will add under application tag)
Note:- (still confuse refer this link -> https://github.com/Justin-roy/Zebra-Rfid-Sdk-Plugin/blob/main/example/android/app/src/main/AndroidManifest.xml#:~:text=%3Cmanifest%20xmlns,ic_launcher%22%3E)
4. minSdkVersion 19 or higher
Ready to use :D
```

## Usage/Examples

```javascript
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
}
```

## Tested on Zebra MC33 Device

## Authors

- [@Justin Roy](https://www.linkedin.com/in/justin-roy-4817551ba/)

## Badges

Add badges from somewhere like: [shields.io](https://shields.io/)

[![MIT License](https://img.shields.io/badge/License-MIT-green.svg)](https://choosealicense.com/licenses/mit/)
[![GPLv3 License](https://img.shields.io/badge/License-GPL%20v3-yellow.svg)](https://opensource.org/licenses/)
[![AGPL License](https://img.shields.io/badge/license-AGPL-blue.svg)](http://www.gnu.org/licenses/agpl-3.0)

## Support

For support, Give a star ⭐ to repo.
