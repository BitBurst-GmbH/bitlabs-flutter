/*
Extension of the String class to convert a json to a HookMessage object
 */
import 'dart:convert';

import 'package:bitlabs/src/utils/sentry_hub.dart';

extension StringExtension on String {
  HookMessage? toHookMessage() {
    final regex = RegExp(
        r'^\{\s*"type"\s*:\s*"hook"\s*,\s*"name"\s*:\s*".*"\s*,\s*"args"\s*:\s*\[.*\]\s*\}$');
    if (!regex.hasMatch(this)) {
      return null;
    }

    try {
      final json = jsonDecode(this);
      return HookMessage.fromJson(json);
    } catch (e) {
      SentryHub().captureException(e);
      return null;
    }
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
      case 'offerwall-core:init':
        return HookName.init;
      case 'offerwall-core:sdk.close':
        return HookName.sdkClose;
      case 'offerwall-surveys:survey.start':
        return HookName.surveyStart;
      case 'offerwall-surveys:survey.complete':
        return HookName.surveyComplete;
      case 'offerwall-surveys:survey.screenout':
        return HookName.surveyScreenout;
      case 'offerwall-surveys:survey.start-bonus':
        return HookName.surveyStartBonus;
      case 'offerwall-identity:offerwall-identity:identity.change':
        return HookName.identityChange;
      default:
        return HookName.unrecognized;
    }
  }

  static String _hookNameToString(HookName name) {
    switch (name) {
      case HookName.init:
        return 'offerwall-core:init';
      case HookName.sdkClose:
        return 'offerwall-core:sdk.close';
      case HookName.surveyStart:
        return 'offerwall-surveys:survey.start';
      case HookName.surveyComplete:
        return 'offerwall-surveys:survey.complete';
      case HookName.surveyScreenout:
        return 'offerwall-surveys:survey.screenout';
      case HookName.surveyStartBonus:
        return 'offerwall-surveys:survey.start-bonus';
      case HookName.identityChange:
        return 'offerwall-identity:offerwall-identity:identity.change';
      default:
        return 'unrecognized';
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
  unrecognized,
}

class RewardArgument {
  final double reward;

  RewardArgument.fromJson(Map<String, dynamic> json)
      : reward = (json['reward'] as num).toDouble();
}

class SurveyStartArgument {
  final String clickId;
  final String linkId;

  SurveyStartArgument.fromJson(Map<String, dynamic> json)
      : clickId = json['clickId'],
        linkId = json['linkId'];
}
