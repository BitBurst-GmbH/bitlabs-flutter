/*
Extension of the String class to convert a json to a HookMessage object
 */
import 'dart:convert';

import 'package:bitlabs/src/models/sentry/sentry_manager.dart';

extension StringExtension on String {
  HookMessage? toHookMessage() {
    try {
      final regex = RegExp(
          r'^\{\s*"type"\s*:\s*"hook"\s*,\s*"name"\s*:\s*".*"\s*,\s*"args"\s*:\s*\[.*\]\s*\}$');
      if (!regex.hasMatch(this)) {
        return null;
      }

      final json = jsonDecode(this);
      return HookMessage.fromJson(json);
    } catch (e, stackTrace) {
      SentryManager().captureEvent(e, stackTrace);
      return null;
    }
  }
}

/*
Class to represent a HookMessage object
 */
class HookMessage {
  late final String type;
  late final HookName name;
  late final List<dynamic> args;

  HookMessage.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    name = _hookNameFromString(json['name']);
    args = json['args'].map((arg) {
      switch (name) {
        case HookName.offerStart:
          return OfferStartArgument.fromJson(arg);
        case HookName.surveyStart:
          return SurveyStartArgument.fromJson(arg);
        case HookName.surveyComplete:
        case HookName.surveyScreenout:
        case HookName.surveyStartBonus:
          return RewardArgument.fromJson(arg);
        case HookName.offerContinue:
          return OfferContinueArgument.fromJson(arg);
        default:
          return arg;
      }
    }).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'name': _hookNameToString(name),
      'args': args.map((arg) {
        switch (name) {
          case HookName.offerStart:
            return {'offer-clickUrl': arg.offer.clickUrl};
          case HookName.surveyStart:
            return {'clickId': arg.clickId, 'link': arg.link};
          case HookName.surveyComplete:
          case HookName.surveyScreenout:
          case HookName.surveyStartBonus:
            return {'reward': arg.reward};
          case HookName.offerContinue:
            return {'link': arg.link};
          default:
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
      case 'offerwall-offers:offer.start':
        return HookName.offerStart;
      case 'offerwall-surveys:survey.start':
        return HookName.surveyStart;
      case 'offerwall-offers:offer.continue':
        return HookName.offerContinue;
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
      case HookName.offerStart:
        return 'offerwall-offers:offer.start';
      case HookName.surveyStart:
        return 'offerwall-surveys:survey.start';
      case HookName.offerContinue:
        return 'offerwall-offers:offer.continue';
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
  offerStart,
  surveyStart,
  unrecognized,
  offerContinue,
  identityChange,
  surveyComplete,
  surveyScreenout,
  surveyStartBonus,
}

class RewardArgument {
  final double reward;

  RewardArgument.fromJson(Map<String, dynamic> json)
      : reward = (json['reward'] as num).toDouble();
}

class SurveyStartArgument {
  final String clickId;
  final String link;

  SurveyStartArgument.fromJson(Map<String, dynamic> json)
      : clickId = json['clickId'],
        link = json['link'];
}

class OfferStartArgument {
  final Offer offer;

  OfferStartArgument.fromJson(Map<String, dynamic> json)
      : offer = Offer.fromJson(json['offer']);
}

class Offer {
  final String clickUrl;

  Offer.fromJson(Map<String, dynamic> json) : clickUrl = json['clickUrl'];
}

class OfferContinueArgument {
  final String link;

  OfferContinueArgument.fromJson(Map<String, dynamic> json)
      : link = json['link'];
}
