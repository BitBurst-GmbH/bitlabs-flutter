import 'sentry_envelope_headers.dart';

abstract class SentryEnvelopeItem
{
}


class SentryEnvelope {
  final SentryEnvelopeHeaders headers;
  final List<SentryEnvelopeItem> items;

  SentryEnvelope({required this.headers, required this.items});

  String toEnvelopeNotation() {
    final header = headers.toJson();
    final item = items.join();
    return '$header\n$item';
  }
}
