import 'dart:ffi';

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

  Map<String, String> toJson() {
    final json = <String, String>{
      'type': type,
      'handled': handled.toString(),
    };

    if (data != null) {
      json['data'] = data.toString();
    }

    if (meta != null) {
      json['meta'] = meta.toString();
    }

    return json;
  }
}
