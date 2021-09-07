import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_social_share/flutter_social_share.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion = await FlutterSocialShare.platformVersion ??
          'Unknown platform version';
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

  Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('assets/$path');

    final file =
        File('${(await getApplicationDocumentsDirectory()).path}/$path');
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }

  @override
  Widget build(BuildContext context) {
    [Permission.storage].request().then((val) {
      val.forEach((key, value) {
        if (value.isPermanentlyDenied) {
          openAppSettings();
        }
      });
    });
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
          brightness: Brightness.dark,
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text('Running on: $_platformVersion\n'),
                ElevatedButton(
                  onPressed: () async {
                    var image =
                        (await getImageFileFromAssets("example.jpg")).uri;
                    var movie =
                        (await getImageFileFromAssets("example.mp4")).uri;
                    var share = await FlutterSocialShare.shareToInstagram(
                      //backgroundAssetUri: movie,
                      stickerAssetUri: image,
                      // topColor: Colors.deepPurple,
                      // bottomColor: Colors.pinkAccent
                    );
                    print(share);
                  },
                  child: Text("Share to Instagram Story"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
