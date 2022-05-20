import 'dart:io' show Platform;

import 'package:flutter/material.dart';

String platform() => Platform.isAndroid ? 'ANDROID' : 'IOS';

// TODO: Add sdk='FLUTTER' parameter
String offerWallUrl(String token, String uid, Map<String, dynamic> tags) =>
    Uri.https('web.bitlabs.ai', '', {
      'token': token,
      'uid': uid,
      ...tags,
    }).toString();

Map<String, String> leaveReasons() => {
      "SENSITIVE": 'Too Sensitive',
      "UNINTERESTING": 'Uninteresting',
      "TECHNICAL": 'Technical Issues',
      "TOO_LONG": 'Too Long',
      "OTHER": 'Other Reasons',
    };

List<Widget> leaveReasonOptions(
        {required void Function(String) leaveSurvey,
        required BuildContext context}) =>
    leaveReasons()
        .entries
        .map(
          (e) => SimpleDialogOption(
            onPressed: () {
              leaveSurvey(e.key);
              Navigator.of(context).pop();
            },
            child: Text(e.value),
          ),
        )
        .toList();
