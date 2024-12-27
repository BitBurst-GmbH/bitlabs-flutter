import 'sentry_excepton_mechanism.dart';
import 'sentry_stack_trace.dart';

class SentryException {
  final String type;
  final String value;
  final String? module;
  final SentryStackTrace? stacktrace;
  final SentryExceptionMechanism? mechanism;

  SentryException({
    required this.type,
    required this.value,
    this.module,
    this.stacktrace,
    this.mechanism,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'type': type,
      'value': value,
    };

    if (module != null) {
      json['module'] = module!;
    }

    if (stacktrace != null) {
      json['stacktrace'] = stacktrace!.toJson();
    }

    if (mechanism != null) {
      json['mechanism'] = mechanism!.toJson();
    }

    return json;
  }
}
