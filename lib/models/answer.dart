class Answer {
  final String code;
  final String localizedText;

  Answer(Map<String, dynamic> json)
      : code = json['code'],
        localizedText = json['localized_text'];

  Map<String, String> toJson() =>
      {'code': code, 'localized_text': localizedText};
}
