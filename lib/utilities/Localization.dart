
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Localization {
  final Locale locale;

  Localization(this.locale);

  static Localization of(BuildContext context) =>
      Localizations.of(context, Localization) ??
      Localization(const Locale('en', ''));

  static const _localizedValues = <String, Map<String, String>>{
    'en': {
      "too_sensitive": "Too sensitive",
      "uninteresting": "Uninteresting",
      "technical_issues": "Technical issues",
      "too_long": "Too long",
      "other_reason": "Other Reason",
      "continue_survey": "Continue with survey",
      "leave_title": "Leave Survey",
      "leave_description": "Choose a reason for leaving the survey",
    },
    'de': {
      "too_sensitive": "Zu sensibel",
      "uninteresting": "Uninteressant",
      "technical_issues": "Technische Probleme",
      "too_long": "Zu lang",
      "other_reason": "Andere Gründe",
      "continue_survey": "Umfrage weitermachen",
      "leave_title": "Umfrage Verlassen",
      "leave_description":
          "Wähle einen Grund warum du die Umfrage verlassen willst",
    },
    'es': {
      "too_sensitive": "Demasiado sensible",
      "uninteresting": "Poco interesante",
      "technical_issues": "Cuestiones técnicas",
      "too_long": "Demasiado largo",
      "other_reason": "Otro motivo",
      "continue_survey": "Continuar con la encuesta",
      "leave_title": "Dejar la encuesta",
      "leave_description": "Elija un motivo para dejar la encuesta",
    },
    'fr': {
      "too_sensitive": "Trop sensible",
      "uninteresting": "Inintéressant",
      "technical_issues": "Problèmes techniques",
      "too_long": "Trop long",
      "other_reason": "Autre raison",
      "continue_survey": "Continuer l'enquête",
      "leave_title": "Quitter l'enquête",
      "leave_description": "Choisissez une raison pour quitter l'enquête",
    },
    'it': {
      "too_sensitive": "Troppo sensibile",
      "uninteresting": "Poco interessante",
      "technical_issues": "Problemi tecnici",
      "too_long": "Troppo lungo",
      "other_reason": "Altro motivo",
      "continue_survey": "Continua con il sondaggio",
      "leave_title": "Lascia il sondaggio",
      "leave_description": "Scegli un motivo per lasciare il sondaggio",
    },
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
