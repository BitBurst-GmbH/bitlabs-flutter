import 'dart:convert';

import 'details.dart';

/// Represents the survey the user can take.
class Survey {
  final int networkId;
  final int id;

  /// In USD without any formatting applied.
  final String cpi;

  /// CPI formatted according to your app settings. Can be shown to the user directly.
  final String value;

  /// Assumed length of the survey in minutes.
  final double loi;

  /// Amount of users that can still open the survey.
  final int remaining;
  final Details details;

  /// Difficulty ranking of this survey. 1-5 (1 = hard, 5 = easy).
  final int rating;

  /// This link can be used as is to open the survey.
  /// All relevant details are inserted on the server.
  final String link;

  /// The number of questions that have to be answered before the survey is
  /// guaranteed to be openable by the user.
  final int? missingQuestions;

  Survey(
      {required this.networkId,
      required this.id,
      required this.cpi,
      required this.value,
      required this.loi,
      required this.remaining,
      required this.details,
      required this.rating,
      required this.link,
      this.missingQuestions});

  Survey.fromJson(Map<String, dynamic> json)
      : networkId = json['network_id'],
        id = json['id'],
        cpi = json['cpi'],
        value = json['value'],
        loi = (json['loi'] as num).toDouble(),
        remaining = json['remaining'],
        details = Details.fromJson(json['details']),
        rating = json['rating'],
        link = json['link'],
        missingQuestions = json.containsKey('missing_questions')
            ? json['missing_questions']
            : null;

  Map<String, dynamic> toJson() => {
        'network_id': networkId,
        'id': id,
        'cpi': cpi,
        'value': value,
        'loi': loi,
        'remaining': remaining,
        'details': details,
        'rating': rating,
        'link': link,
        'missing_questions': missingQuestions
      };

  @override
  String toString() => jsonEncode(this);
}
