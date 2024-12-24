import 'dart:convert';
import 'dart:math';

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
import 'sentry_service.dart';

class SentryRepository {
  final SentryService _sentryService;
  final String token;
  final String uid;

  SentryRepository(this._sentryService, this.token, this.uid);

  void sendEnvelope(Object errorOrException, StackTrace stacktrace) async {
    final envelope = createEnvelope(errorOrException, stacktrace);
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
      Object errorOrException, StackTrace stacktrace) {
    final eventId = _generateEventId().replaceAll('-', '');
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
      mechanism: SentryExceptionMechanism(handled: true),
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

  String _generateEventId() {
    final random = Random.secure();
    return List.generate(16, (index) {
      int value = random.nextInt(256);
      if (index == 6) {
        value = (value & 0x0F) | 0x40; // version 4
      } else if (index == 8) {
        value = (value & 0x3F) | 0x80; // variant 1
      }
      return value.toRadixString(16).padLeft(2, '0');
    }).join().replaceAllMapped(
        RegExp(r'(.{8})(.{4})(.{4})(.{4})(.{12})'),
        (match) =>
            '${match[1]}-${match[2]}-${match[3]}-${match[4]}-${match[5]}');
  }
}
