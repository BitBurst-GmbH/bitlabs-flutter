import 'sentry_excepton_mechanism.dart';
import 'sentry_stack_trace.dart';

class SentryException {
  final String type;
  final String value;
  final String? module;
  final SentryStackTrace? stackTrace;
  final SentryExceptionMechanism? mechanism;

  SentryException({
    required this.type,
    required this.value,
    this.module,
    this.stackTrace,
    this.mechanism,
  });

  Map<String, String> toJson() {
    final json = <String, String>{
      'type': type,
      'value': value,
    };

    if (module != null) {
      json['module'] = module!;
    }

    if (stackTrace != null) {
      json['stack_trace'] = stackTrace!.toJson().toString();
    }

    if (mechanism != null) {
      json['mechanism'] = mechanism!.toJson().toString();
    }

    return json;
  }
}
