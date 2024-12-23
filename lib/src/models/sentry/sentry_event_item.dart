import 'dart:convert';

import 'sentry_envelope.dart';
import 'sentry_event.dart';

class SentryEventItem implements SentryEnvelopeItem {
  final SentryEvent event;

  SentryEventItem({required this.event});

  @override
  String toString() {
    final eventJson = jsonEncode(event.toJson());
    final itemHeadersJson = jsonEncode({
      'type': 'event',
      'length': eventJson.length,
    });

    return '$itemHeadersJson\n$eventJson';
  }
}
