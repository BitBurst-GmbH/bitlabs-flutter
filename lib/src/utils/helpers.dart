import 'dart:io' show Platform;

import 'package:flutter/material.dart';

import 'localization.dart';

String platform = Platform.isAndroid ? 'ANDROID' : 'IOS';

// TODO: Add sdk='FLUTTER' parameter
String offerWallUrl(String token, String uid, Map<String, dynamic> tags) =>
    Uri.https('web.bitlabs.ai', '', {
      'token': token,
      'uid': uid,
      ...tags,
    }).toString();

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
