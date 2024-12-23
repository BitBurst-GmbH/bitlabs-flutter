import 'sentry_stack_frame.dart';

class SentryStackTrace {
  final List<SentryStackFrame> frames;

  SentryStackTrace({
    required this.frames,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'frames': frames.map((frame) => frame.toJson()).toList(),
    };

    return json;
  }
}
