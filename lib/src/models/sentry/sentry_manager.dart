import 'package:bitlabs/src/api/sentry/sentry_service.dart';
import 'package:bitlabs/src/models/sentry/sentry_dsn.dart';

import '../../api/sentry/sentry_repository.dart';

class SentryManager {
  static final SentryManager _instance = SentryManager._internal();

  final SentryDsn dsn;
  late final String projectId;

  late final String _host;
  late final String _protocol;
  late final String _publicKey;

  SentryRepository? _sentryRepository;

  factory SentryManager() => _instance;

  SentryManager._internal()
      : dsn = SentryDsn(
          dsn:
              'https://6c204d9e07470b969bfb7de16fbd64f6@o494432.ingest.us.sentry.io/4508302031781888',
        ) {
    _host = dsn.host;
    _protocol = dsn.protocol;
    _publicKey = dsn.publicKey;
    projectId = dsn.projectId;
  }

  void init(String token, String uid) {
    final headers = {
      'X-Sentry-Auth':
          'Sentry sentry_version=7, sentry_key=$_publicKey, sentry_client=bitlabs-sdk/0.1.0',
      'User-Agent': 'bitlabs-sdk/0.1.0',
    };

    _sentryRepository = SentryRepository(SentryService(token, uid), token, uid);
  }

  void sendEnvelope(Exception exception, StackTrace stackTrace) {
    _sentryRepository?.sendEnvelope(exception, stackTrace);
  }

  Uri get sentryUri =>
      Uri.parse('$_protocol://$_host/api/$projectId/envelope/');
}
