import 'dart:io';
import 'dart:math';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';

Future<String> getUserAgent() async {
  String info = '';

  final deviceInfo = DeviceInfoPlugin();
  if (Platform.isAndroid) {
    final androidInfo = await deviceInfo.androidInfo;
    final version = androidInfo.version.release;
    final manufacturer = androidInfo.manufacturer;
    final model = androidInfo.model;

    info = 'Android $version; $manufacturer $model; ${getDeviceType()}';
  } else if (Platform.isIOS) {
    final iosInfo = await deviceInfo.iosInfo;
    final version = iosInfo.systemVersion;
    final name = iosInfo.name;
    final model = iosInfo.model;

    info = 'iOS $version; $name; ${getDeviceType()}';
  }

  return 'BitLabs/1.0.0 ($info)';
}

String getDeviceType() {
  final size = MediaQueryData.fromView(
    WidgetsBinding.instance.platformDispatcher.views.first,
  ).size;
  var width = size.width;
  var height = size.height;

  var diagonal = sqrt((width * width) + (height * height));

  return diagonal > 1100.0 ? 'Tab' : 'Phone'; // Adjust threshold as needed
}
