import 'dart:io' show Platform;
import 'dart:math';

import 'package:flutter/material.dart';

import '../models/category.dart';
import '../models/details.dart';
import '../models/survey.dart';
import 'localization.dart';

String platform = Platform.isAndroid ? 'ANDROID' : 'IOS';

List<Survey> randomSurveys() {
  final random = Random();
  var surveys = <Survey>[];

  for (var i = 1; i <= 3; i++) {
    surveys.add(Survey(
        networkId: random.nextInt(1000),
        id: i,
        cpi: '0.5',
        value: '0.5',
        loi: random.nextDouble(),
        remaining: 3,
        details: Details(category: Category(name: 'General', iconUrl: '')),
        rating: random.nextInt(5),
        link: '',
        missingQuestions: 0));
  }

  return surveys;
}

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

Color colorFromHex(String hex) {
  hex = hex.replaceAll('#', '').toUpperCase();
  if (hex.length == 6) hex = 'FF$hex';
  return Color(int.parse(hex, radix: 16));
}
