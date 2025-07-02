import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'bitlabs_platform_interface.dart';

/// An implementation of [BitlabsPlatform] that uses method channels.
class MethodChannelBitlabs extends BitlabsPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('bitlabs');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
