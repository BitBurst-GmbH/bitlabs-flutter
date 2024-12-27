class SentryExceptionMechanism {
  final String type;
  final bool handled;
  final Map<String, String>? data;
  final Map<String, String>? meta;

  SentryExceptionMechanism({
    this.type = 'generic',
    this.handled = true,
    this.data,
    this.meta,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'type': type,
      'handled': handled,
    };

    if (data != null) {
      json['data'] = data;
    }

    if (meta != null) {
      json['meta'] = meta;
    }

    return json;
  }
}
