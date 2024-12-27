import 'dart:convert';

import 'package:bitlabs/src/models/sentry/send_envelope_response.dart';
import 'package:flutter/foundation.dart';

import '../../models/sentry/sentry_envelope.dart';
import '../../models/sentry/sentry_envelope_headers.dart';
import '../../models/sentry/sentry_event.dart';
import '../../models/sentry/sentry_event_item.dart';
import '../../models/sentry/sentry_exception.dart';
import '../../models/sentry/sentry_excepton_mechanism.dart';
import '../../models/sentry/sentry_manager.dart';
import '../../models/sentry/sentry_message.dart';
import '../../models/sentry/sentry_sdk.dart';
import '../../models/sentry/sentry_stack_frame.dart';
import '../../models/sentry/sentry_stack_trace.dart';
import '../../models/sentry/sentry_user.dart';
import '../../utils/helpers.dart';
import 'sentry_service.dart';

class SentryRepository {
  final SentryService _sentryService;
  final String token;
  final String uid;

  SentryRepository(this._sentryService, this.token, this.uid);

  void sendEnvelope(
    Object errorOrException,
    StackTrace stacktrace,
    bool isHandled,
  ) async {
    final envelope = createEnvelope(errorOrException, stacktrace, isHandled);
    try {
      final response = await _sentryService.sendEnvelope(envelope);

      if (response.statusCode != 200) {
        debugPrint('Error sending envelope: ${response.body}');
        return;
      }

      final body = SendEnvelopeResponse(jsonDecode(response.body));
      debugPrint('Envelope(#${body.id}) sent to Sentry');
    } catch (e) {
      debugPrint('Error sending envelope: $e');
    }
  }

  SentryEnvelope createEnvelope(
    Object errorOrException,
    StackTrace stacktrace,
    bool isHandled,
  ) {
    final eventId = generateV4UUID().replaceAll('-', '');
    final now = DateTime.now().toUtc().toIso8601String();

    final exception = SentryException(
      type: errorOrException.runtimeType.toString(),
      value: errorOrException.toString(),
      stacktrace: SentryStackTrace(
        frames: stacktrace.toString().split('\n').map((line) {
          return SentryStackFrame(
            function: line,
            module: 'flutter',
            lineno: 0,
            inApp: line.contains('package:bitlabs'),
          );
        }).toList(),
      ),
      mechanism: SentryExceptionMechanism(handled: isHandled),
    );

    final event = SentryEvent(
      eventId: eventId,
      timestamp: now,
      logentry: SentryMessage(formatted: errorOrException.toString()),
      user: SentryUser(id: uid),
      sdk: SentrySDK(version: '0.1.0'),
      exception: [exception],
      tags: {'token': token},
      level: 'error',
    );

    final eventItem = SentryEventItem(event: event);

    return SentryEnvelope(
      headers: SentryEnvelopeHeaders(
        eventId: eventId,
        sentAt: now,
        dsn: SentryManager().dsn.toString(),
      ),
      items: [eventItem],
    );
  }
}
