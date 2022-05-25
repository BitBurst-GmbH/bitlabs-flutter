import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

part '../localizations/de.dart';

part '../localizations/en.dart';

part '../localizations/es.dart';

part '../localizations/fr.dart';

part '../localizations/it.dart';

class Localization {
  final Locale locale;

  Localization(this.locale);

  static Localization of(BuildContext context) =>
      Localizations.of(context, Localization) ??
      Localization(const Locale('en', ''));

  static const _localizedValues = <String, Map<String, String>>{
    'en': _en,
    'de': _de,
    'es': _es,
    'fr': _fr,
    'it': _it,
  };

  static List<String> languages() => _localizedValues.keys.toList();

  String get tooSensitive =>
      _localizedValues[locale.languageCode]!['too_sensitive']!;

  String get uninteresting =>
      _localizedValues[locale.languageCode]!['uninteresting']!;

  String get technicalIssues =>
      _localizedValues[locale.languageCode]!['technical_issues']!;

  String get tooLong => _localizedValues[locale.languageCode]!['too_long']!;

  String get otherReason =>
      _localizedValues[locale.languageCode]!['other_reason']!;

  String get continueSurvey =>
      _localizedValues[locale.languageCode]!['continue_survey']!;

  String get leaveTitle =>
      _localizedValues[locale.languageCode]!['leave_title']!;

  String get leaveDescription =>
      _localizedValues[locale.languageCode]!['leave_description']!;
}

class LocalizationDelegate extends LocalizationsDelegate<Localization> {
  @override
  bool isSupported(Locale locale) =>
      Localization.languages().contains(locale.languageCode);

  @override
  Future<Localization> load(Locale locale) =>
      SynchronousFuture<Localization>(Localization(locale));

  @override
  bool shouldReload(covariant LocalizationsDelegate<Localization> old) => false;
}
