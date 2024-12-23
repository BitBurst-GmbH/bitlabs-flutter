import 'package:bitlabs/src/models/sentry/sentry_envelope.dart';
import 'package:bitlabs/src/models/sentry/sentry_manager.dart';
import 'package:http/http.dart';

class SentryService {
  final Map<String, String> _headers;

  SentryService(String token, String uid)
      : _headers = {
          'X-Api-Token': token,
          'X-User-Id': uid,
        };

  Future<Response> sendEnvelope(SentryEnvelope envelope) => post(
      SentryManager().sentryUri,
      headers: {..._headers, 'Content-Type': 'application/x-sentry-envelope'},
      body: envelope.toEnvelopeNotation());
}
