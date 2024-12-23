class SentryMessage {
  final String formatted;
  final String? message;
  final List<String>? params;

  SentryMessage({
    required this.formatted,
    this.message,
    this.params,
  });

  Map<String, String> toJson() {
    final json = <String, String>{
      'formatted': formatted,
    };

    if (message != null) {
      json['message'] = message!;
    }

    if (params != null) {
      json['params'] = params!.toString();
    }

    return json;
  }
}
