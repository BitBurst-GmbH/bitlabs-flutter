import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'bitlabs.dart';
import 'bitlabs_platform_interface.dart';

/// An implementation of [BitlabsPlatform] that uses method channels.
class MethodChannelBitlabs extends BitlabsPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('bitlabs');

  void Function(double reward) _onReward = (reward) {};

  Future<dynamic> methodCallHandler(MethodCall call) async {
    switch (call.method) {
      case 'onReward':
        final reward = call.arguments['reward'] as double;
        _onReward(reward);
        return 'called onReward';
      default:
        throw MissingPluginException('notImplemented');
    }
  }

  MethodChannelBitlabs() {
    methodChannel.setMethodCallHandler(methodCallHandler);
  }

  @override
  Future<void> init(String token, String uid) async {
    await methodChannel.invokeMethod('init', {'token': token, 'uid': uid});
  }

  @override
  void setOnRewardCallback(Function(double reward) onReward) {
    _onReward = onReward;
  }

  @override
  Future<void> addTag(String key, String value) async {
    await methodChannel.invokeMethod('addTag', {'key': key, 'value': value});
  }

  @override
  Future<void> setTags(Map<String, dynamic> tags) async {
    await methodChannel.invokeMethod('setTags', {'tags': tags});
  }

  @override
  Future<void> launchOfferWall() async {
    await methodChannel.invokeMethod('launchOfferWall');
  }

  @override
  Future<void> getSurveys(
    void Function(List<Survey>) onResponse,
    void Function(Exception) onFailure,
  ) async {
    try {
      final List result = await methodChannel.invokeMethod('getSurveys');

      final surveys = result.map((item) => Survey.fromJson(item)).toList();

      onResponse(surveys);
    } on PlatformException catch (e) {
      onFailure(Exception(e.message));
    } catch (e) {
      onFailure(Exception(e));
    }
  }

  @override
  Future<void> checkSurveys(
    void Function(bool) onResponse,
    void Function(Exception) onFailure,
  ) async {
    try {
      final bool surveysExist =
          await methodChannel.invokeMethod('checkSurveys');

      onResponse(surveysExist);
    } on PlatformException catch (e) {
      onFailure(Exception(e.message));
    } catch (e) {
      onFailure(Exception(e));
    }
  }

  @override
  Future<void> requestTrackingAuthorization() async {
    await methodChannel.invokeMethod('requestTrackingAuthorization');
  }
}
