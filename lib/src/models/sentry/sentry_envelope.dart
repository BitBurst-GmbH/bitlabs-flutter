import 'dart:convert';

import 'sentry_envelope_headers.dart';

abstract class SentryEnvelopeItem {}

class SentryEnvelope {
  final SentryEnvelopeHeaders headers;
  final List<SentryEnvelopeItem> items;

  SentryEnvelope({required this.headers, required this.items});

  @override
  String toString() {
    final header = jsonEncode(headers.toJson());
    final item = items.join('\n');
    return '$header\n$item';
  }

  List<int> toEnvelopeNotation() => utf8.encode(toString());
}
