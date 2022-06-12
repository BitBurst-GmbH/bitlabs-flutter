import 'dart:io' show Platform;

import 'package:flutter/material.dart';

import 'localization.dart';

String platform = Platform.isAndroid ? 'ANDROID' : 'IOS';

// TODO: Add sdk='FLUTTER' parameter
String offerWallUrl(
    String token, String uid, String adId, Map<String, dynamic> tags) {
  final queries = {
    'token': token,
    'uid': uid,
    ...tags,
  };
  if (adId.isNotEmpty) queries['maid'] = adId;
  return Uri.https('web.bitlabs.ai', '', queries).toString();
}

// TODO: Add sdk='FLUTTER' parameter
Uri url(String path, [Map? queries]) => Uri.https(
      'api.bitlabs.ai',
      'v1/client/$path',
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
