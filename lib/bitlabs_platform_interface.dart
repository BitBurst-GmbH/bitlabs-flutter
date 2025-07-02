import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'bitlabs_method_channel.dart';

abstract class BitlabsPlatform extends PlatformInterface {
  /// Constructs a BitlabsPlatform.
  BitlabsPlatform() : super(token: _token);

  static final Object _token = Object();

  static BitlabsPlatform _instance = MethodChannelBitlabs();

  /// The default instance of [BitlabsPlatform] to use.
  ///
  /// Defaults to [MethodChannelBitlabs].
  static BitlabsPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [BitlabsPlatform] when
  /// they register themselves.
  static set instance(BitlabsPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
