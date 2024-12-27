import 'dart:io' show Platform;
import 'dart:math';

import 'package:bitlabs/src/utils/constants.dart';
import 'package:flutter/material.dart';

import 'localization.dart';

final system = Platform.isAndroid ? 'ANDROID' : 'IOS';

final adGateSupportUrlRegex =
    RegExp(r'https://wall\.adgaterewards\.com/(.*/)*contact/');

String offerWallUrl(
    String token, String uid, String adId, Map<String, dynamic> tags) {
  final queries = {
    ...tags,
    'uid': uid,
    'token': token,
    'sdk': 'FLUTTER',
    'os': Platform.isIOS ? 'ios' : 'android',
  };
  if (adId.isNotEmpty) queries['maid'] = adId;
  return Uri.https(BASE_URL, '', queries).toString();
}

Uri url(String path, [Map? queries]) => Uri.https(
      'api.bitlabs.ai',
      path,
      {...?queries, 'platform': 'MOBILE'},
    );

List<Widget> leaveReasonOptions({
  required void Function(String) leaveSurvey,
  required BuildContext context,
}) =>
    _reasons(context)
        .entries
        .map((e) => SimpleDialogOption(
            onPressed: () {
              leaveSurvey(e.key);
              Navigator.of(context).pop();
            },
            child: Text(e.value)))
        .toList();

Map<String, String> _reasons(BuildContext context) => {
      "SENSITIVE": Localization.of(context).tooSensitive,
      "UNINTERESTING": Localization.of(context).uninteresting,
      "TECHNICAL": Localization.of(context).technicalIssues,
      "TOO_LONG": Localization.of(context).tooLong,
      "OTHER": Localization.of(context).otherReason,
    };

String generateV4UUID() {
  final random = Random.secure();
  return List.generate(16, (index) {
    int value = random.nextInt(256);
    if (index == 6) {
      value = (value & 0x0F) | 0x40; // version 4
    } else if (index == 8) {
      value = (value & 0x3F) | 0x80; // variant 1
    }
    return value.toRadixString(16).padLeft(2, '0');
  }).join().replaceAllMapped(RegExp(r'(.{8})(.{4})(.{4})(.{4})(.{12})'),
      (match) => '${match[1]}-${match[2]}-${match[3]}-${match[4]}-${match[5]}');
}
