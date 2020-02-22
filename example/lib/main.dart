import 'package:flutter/material.dart';
import 'dart:async';

import 'package:notify/notify.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    // String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    final notify = Notify();
    final bundle = await notify.getBundleIdentifier("firefox");
    await notify.setApplication(bundle);
    await notify.sendNotification(
        title: "Danger",
        subtitle: "Will Robinson",
        message: "Run away as fast as you can",
        sound: "Blow");

    //  try {
    //     platformVersion = await Notify;
    //   } on PlatformException {
    //     platformVersion = 'Failed to get platform version.';
    //   }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    // if (!mounted) return;

    // setState(() {
    //   _platformVersion = platformVersion;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Running on: '),
        ),
      ),
    );
  }
}
