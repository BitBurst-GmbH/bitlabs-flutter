import 'dart:convert';

import '../../utils/extensions.dart';

import 'category.dart';

/// Represents the survey the user can take.
class Survey {
  final String id;

  /// Values are **survey** or **start_bonus**.
  final String type;

  /// This link can be used as is to open the survey.
  /// All relevant details are inserted on the server.
  final String clickUrl;

  /// In USD without any formatting applied.
  final String cpi;

  /// CPI formatted according to your app settings. Can be shown to the user directly.
  final String value;

  /// Assumed length of the survey in minutes.
  final double loi;

  /// ISO 3166-1 ALPHA-2
  final String country;

  /// ISO 639-1
  final String language;

  /// Difficulty ranking of this survey. 1-5 (1 = hard, 5 = easy).
  final int rating;
  final Category category;

  /// Values are **recontact** or **pii**. The tag **recontact** means that this
  /// is a follow-up survey for specific users that completed a different survey before;
  /// The tag **pii** means that this survey might collect sensitive information from the user;
  final List<String> tags;

  Survey(
      {required this.id,
      required this.type,
      required this.clickUrl,
      required this.cpi,
      required this.value,
      required this.loi,
      required this.country,
      required this.language,
      required this.rating,
      required this.category,
      required this.tags});

  Survey.fromJson(Map json)
      : id = json.getValue('id'),
        type = json.getValue('type'),
        clickUrl = json.getValue('clickUrl'),
        cpi = json.getValue('cpi'),
        value = json.getValue('value'),
        loi = json.getValue<num>('loi').toDouble(),
        country = json.getValue('country'),
        language = json.getValue('language'),
        rating = json.getValue('rating'),
        category = Category.fromJson(json.getValue('category')),
        tags = List<String>.from(json.getValue('tags'));

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'click_url': clickUrl,
        'cpi': cpi,
        'value': value,
        'loi': loi,
        'country': country,
        'language': language,
        'rating': rating,
        'category': category.toJson(),
        'tags': tags
      };

  @override
  String toString() => jsonEncode(this);
}
