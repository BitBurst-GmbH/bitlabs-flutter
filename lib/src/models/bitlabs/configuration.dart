class Configuration {
  final String internalIdentifier;
  final String? value;

  Configuration(Map<String, dynamic> json)
      : internalIdentifier = json['internalIdentifier'] as String,
        value = json['value'] is String ? json['value'] as String : null;

  Map<String, dynamic> toJson() => {
        'internalIdentifier': internalIdentifier,
        'value': value,
      };
}
