import 'sentry_exception.dart';
import 'sentry_message.dart';
import 'sentry_sdk.dart';
import 'sentry_user.dart';

class SentryEvent {
  final String eventId;
  final String timestamp;
  final SentryMessage? logentry;
  final String? level;
  final String platform;
  final String? logger;
  final String? serverName;
  final String? release;
  final String? environment;
  final Map<String, String>? modules;
  final Map<String, String>? extra;
  final Map<String, String>? tags;
  final List<String>? fingerprint;
  final SentryUser? user;
  final SentrySDK? sdk;
  final List<SentryException>? exception;

  SentryEvent({
    required this.eventId,
    required this.timestamp,
    this.logentry,
    this.level,
    this.platform = "other",
    this.logger,
    this.serverName,
    this.release,
    this.environment,
    this.modules,
    this.extra,
    this.tags,
    this.fingerprint,
    this.user,
    this.sdk,
    this.exception,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'event_id': eventId,
      'timestamp': timestamp,
      'platform': platform,
    };

    if (logentry != null) {
      json['logentry'] = logentry!.toJson();
    }

    if (level != null) {
      json['level'] = level!;
    }

    if (logger != null) {
      json['logger'] = logger!;
    }

    if (serverName != null) {
      json['server_name'] = serverName!;
    }

    if (release != null) {
      json['release'] = release!;
    }

    if (environment != null) {
      json['environment'] = environment!;
    }

    if (modules != null) {
      json['modules'] = modules!;
    }

    if (extra != null) {
      json['extra'] = extra!;
    }

    if (tags != null) {
      json['tags'] = tags!;
    }

    if (fingerprint != null) {
      json['fingerprint'] = fingerprint!;
    }

    if (user != null) {
      json['user'] = user!.toJson();
    }

    if (sdk != null) {
      json['sdk'] = sdk!.toJson();
    }

    if (exception != null) {
      json['exception'] =
          exception!.map((exception) => exception.toJson()).toList();
    }

    return json;
  }
}
