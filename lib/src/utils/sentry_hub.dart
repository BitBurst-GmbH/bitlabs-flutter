import 'dart:io';

import 'package:bitlabs/secrets.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class SentryHub {
  static final isEnvTesting = Platform.environment.containsKey('FLUTTER_TEST');
  static final Hub? _hub = Platform.environment.containsKey('FLUTTER_TEST')
      ? null
      : Hub(SentryOptions(dsn: sentryDSN));

  static void init(String token, String uid) {
    _hub?.configureScope((scope) {
      scope.setUser(SentryUser(id: uid));
      scope.setTag('token', token);
    });
  }

  static void captureException(dynamic exception) {
    _hub?.captureException(exception);
  }
}
