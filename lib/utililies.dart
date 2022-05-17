import 'dart:io' show Platform;

String platform() => Platform.isAndroid ? 'ANDROID' : 'IOS';
