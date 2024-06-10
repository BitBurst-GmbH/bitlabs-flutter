/*
Extension of the String class to convert a json to a HookMessage object
 */
import 'dart:convert';
import 'dart:ffi';

extension StringExtension on String {
  HookMessage toHookMessage() {
    final json = jsonDecode(this);
    return HookMessage.fromJson(json);
  }
}

/*
Class to represent a HookMessage object
 */
class HookMessage {
  final String type;
  final HookName name;
  final List<String> args;

  HookMessage.fromJson(Map<String, dynamic> json)
      : type = json['type'],
        name = _hookNameFromString(json['name']),
        args = List<String>.from(json['args']);

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'name': _hookNameToString(name),
      'args': args,
    };
  }

  static HookName _hookNameFromString(String name) {
    switch (name) {
      case "offerwall-core:init":
        return HookName.init;
      case "offerwall-core:sdk.close":
        return HookName.sdkClose;
      case "offerwall-core:survey.start":
        return HookName.surveyStart;
      case "offerwall-core:survey.complete":
        return HookName.surveyComplete;
      case "offerwall-core:survey.screenout":
        return HookName.surveyScreenout;
      case "offerwall-core:survey.startBonus":
        return HookName.surveyStartBonus;
      default:
        throw ArgumentError('Invalid hook name');
    }
  }

  static String _hookNameToString(HookName name) {
    switch (name) {
      case HookName.init:
        return "offerwall-core:init";
      case HookName.sdkClose:
        return "offerwall-core:sdk.close";
      case HookName.surveyStart:
        return "offerwall-core:survey.start";
      case HookName.surveyComplete:
        return "offerwall-core:survey.complete";
      case HookName.surveyScreenout:
        return "offerwall-core:survey.screenout";
      case HookName.surveyStartBonus:
        return "offerwall-core:survey.startBonus";
    }
  }

  @override
  String toString() => jsonEncode(this);
}

/*
Enum to represent the different hook names with their respective string values
 */
enum HookName {
  init,
  sdkClose,
  surveyStart,
  surveyComplete,
  surveyScreenout,
  surveyStartBonus,
}
