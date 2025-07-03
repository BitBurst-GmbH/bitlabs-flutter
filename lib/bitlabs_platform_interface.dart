import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'bitlabs.dart';
import 'bitlabs_method_channel.dart';

abstract class BitlabsPlatform extends PlatformInterface {
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

  Future<void> init(String token, String uid);

  void setOnRewardCallback(Function(double reward) onReward);

  Future<void> setTags(Map<String, dynamic> tags);

  Future<void> addTag(String key, String value);

  Future<void> launchOfferWall();

  Future<void> getSurveys(
    void Function(List<Survey>) onResponse,
    void Function(Exception) onFailure,
  );

  Future<void> checkSurveys(
    void Function(bool) onResponse,
    void Function(Exception) onFailure,
  );

  Future<void> requestTrackingAuthorization();
}
