import 'package:http/http.dart';

class SentryService {
  final Map<String, String> _headers;

  SentryService(String token, String uid)
      : _headers = {
          'X-Api-Token': token,
          'X-User-Id': uid,
        };

  Future<Response> sendEnvelope(String projectId, String envelope) => post(
      sentryUrl('api/$projectId/envelope/'),
      headers: {..._headers, 'Content-Type': 'application/x-sentry-envelope'},
      body: envelope);

  Uri sentryUrl(String path) => Uri(
        scheme: 'https',
        host: 'sentry.io',
        path: path,
      );
}
