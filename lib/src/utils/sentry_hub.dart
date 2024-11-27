import 'package:bitlabs/secrets.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class SentryHub {
  static final Hub _hub = Hub(SentryOptions(dsn: sentryDSN));

  static void init(String token, String uid) {
    _hub.configureScope((scope) {
      scope.setUser(SentryUser(id: uid));
      scope.setTag('token', token);
    });
  }

  static Future<SentryId> captureException(dynamic exception) {
    return _hub.captureException(exception);
  }
}
