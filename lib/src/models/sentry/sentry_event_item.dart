import 'sentry_envelope.dart';
import 'sentry_event.dart';

class SentryEventItem implements SentryEnvelopeItem {
  final SentryEvent event;

  SentryEventItem({required this.event});

  @override
  String toString() {
    final eventJson = event.toJson();
    final itemHeadersJson = {
      'type': 'event',
      'length': eventJson.length.toString()
    };

    return '${itemHeadersJson.toString()}\n${eventJson.toString()}';
  }
}
