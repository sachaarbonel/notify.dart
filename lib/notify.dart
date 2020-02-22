import 'dart:async';

import 'package:flutter/services.dart';

class Notify {
  static const MethodChannel _channel = const MethodChannel('notify');
  Future<String> getBundleIdentifier(String appName) async {
    final result = await _channel.invokeMethod(
        'getBundleIdentifier', <String, dynamic>{'appName': appName});
    return result;
  }

  Future<void> setApplication(String newbundleIdentifier) async {
    await _channel.invokeMethod('setApplication',
        <String, dynamic>{'newbundleIdentifier': newbundleIdentifier});
  }

  Future<void> sendNotification(
      {String title, String subtitle, String message, String sound}) async {
    await _channel.invokeMethod('sendNotification', <String, dynamic>{
      "title": title,
      "subtitle": subtitle,
      "message": message,
      "sound": sound
    });
  }
}
