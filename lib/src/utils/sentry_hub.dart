import 'package:bitlabs/secrets.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class SentryHub {
  static final SentryHub _instance = SentryHub._internal();
  final Hub _hub;

  factory SentryHub() => _instance;

  SentryHub._internal() : _hub = Hub(SentryOptions(dsn: sentryDSN));

  Future<SentryId> captureException(dynamic exception) {
    return _hub.captureException(exception);
  }
}
