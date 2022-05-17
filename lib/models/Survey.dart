import 'dart:convert';

import 'package:bitlabs/models/details.dart';

class Survey {
  final int networkId;
  final int id;
  final String cpi;
  final String value;
  final double loi;
  final int remaining;
  final Details details;
  final int rating;
  final String link;
  final int? missingQuestions;

  Survey(Map<String, dynamic> json)
      : networkId = json['network_id'],
        id = json['id'],
        cpi = json['cpi'],
        value = json['value'],
        loi = (json['loi'] as num).toDouble(),
        remaining = json['remaining'],
        details = Details(json['details']),
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
