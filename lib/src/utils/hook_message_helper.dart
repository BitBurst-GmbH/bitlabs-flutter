/*
Extension of the String class to convert a json to a HookMessage object
 */
import 'dart:convert';

extension StringExtension on String {
  HookMessage? toHookMessage() {
    final regex = RegExp(r'^\{"type":"hook","name":".*","args":\[.*\]\}$');
    if (!regex.hasMatch(this)) {
      return null;
    }

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
  final List<dynamic> args;

  HookMessage.fromJson(Map<String, dynamic> json)
      : type = json['type'],
        name = _hookNameFromString(json['name']),
        args = json['args'].map((arg) {
          if (arg['reward'] != null) {
            return RewardArgument.fromJson(arg);
          } else if (arg['clickId'] != null) {
            return SurveyStartArgument.fromJson(arg);
          } else {
            return arg;
          }
        }).toList();

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'name': _hookNameToString(name),
      'args': args.map((arg) {
        if (arg is RewardArgument) {
          return {'reward': arg.reward};
        } else if (arg is SurveyStartArgument) {
          return {'clickId': arg.clickId, 'linkId': arg.linkId};
        } else {
          return arg;
        }
      }).toList(),
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
      case "offerwall-identity:offerwall-identity:identity.change":
        return HookName.identityChange;
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
      case HookName.identityChange:
        return "offerwall-identity:offerwall-identity:identity.change";
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
  identityChange,
  surveyComplete,
  surveyScreenout,
  surveyStartBonus,
}

class RewardArgument {
  final double reward;

  RewardArgument.fromJson(Map<String, dynamic> json) : reward = json['reward'];
}

class SurveyStartArgument {
  final String clickId;
  final String linkId;

  SurveyStartArgument.fromJson(Map<String, dynamic> json)
      : clickId = json['clickId'],
        linkId = json['linkId'];
}
