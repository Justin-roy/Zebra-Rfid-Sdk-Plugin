# Zebra Rfid SDK Plugin

Zebra RFID is a technology provided by Zebra Technologies that uses radio waves to automatically identify and track objects. It consists of RFID tags attached to objects, RFID readers that capture tag information, and software that processes and utilizes the data. Zebra's RFID solutions help businesses improve efficiency, accuracy, and visibility in areas such as inventory management, asset tracking, and supply chain operations. They enable organizations to automate data capture, reduce manual efforts, and gain real-time insights into their operations, leading to enhanced productivity and better customer experiences.

## Steps to follow
1. Run command to add package:

   ```javascript
   flutter pub add zebra_rfid_sdk_plugin
   ```
2. Create android/RFIDAPI3Library folder

3. Download both [build.gradle](https://github.com/Justin-roy/Zebra-Rfid-Sdk-Plugin/blob/main/android/RFIDAPI3Library/build.gradle) and [RFIDAPI3Library.aar](https://github.com/Justin-roy/Zebra-Rfid-Sdk-Plugin/blob/main/android/RFIDAPI3Library/RFIDAPI3Library.aar) and copy to android/RFIDAPI3Library

4. In android/settings.gradle add the following line to the top of the file:
   ```javascript
   include ':app',':RFIDAPI3Library' //RFIDAPI3Library is folder name
   
5. In build.gradle add below lines. // app level (android/app/build.gradle)

   ```javascript
    dependencies {
     implementation project(":RFIDAPI3Library",)
     }
     //RFIDAPI3Library is folder name
   ```
6. Add below line to Android.xml
 
   ```javascript
    xmlns:tools="http://schemas.android.com/tools" // this will under manifest tag
    tools:replace="android:label" // this will add under application tag
   ```
7. In android/app/build.gradle set minSdkVersion 19 or higher

 - Ready to use :D 
    
- Still confused? Refer to [the example app](https://github.com/Justin-roy/Zebra-Rfid-Sdk-Plugin/tree/main/example)
    

## Examples

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

<img width="300" src="https://firebasestorage.googleapis.com/v0/b/instagram-clone-cf306.appspot.com/o/post%2FpQOrbpA3fUWWHz7dcBOwxaXn27N2%2FMC33_device.jpeg?alt=media&token=8868364e-a758-4c7d-9265-e50003bbfd72"> 


## Authors

- [@Justin Roy](https://www.linkedin.com/in/justin-roy-4817551ba/)

## Badges

[![MIT License](https://img.shields.io/badge/License-MIT-green.svg)](https://choosealicense.com/licenses/mit/)
[![GPLv3 License](https://img.shields.io/badge/License-GPL%20v3-yellow.svg)](https://opensource.org/licenses/)
[![AGPL License](https://img.shields.io/badge/license-AGPL-blue.svg)](http://www.gnu.org/licenses/agpl-3.0)

## Support

For support, give a star ⭐ to repo.
