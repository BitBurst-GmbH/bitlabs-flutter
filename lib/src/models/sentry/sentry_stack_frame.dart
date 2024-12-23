class SentryStackFrame {
  String? filename;
  String? function;
  String? module;
  int? lineno;
  int? colno;
  String? absPath;
  String? contextLine;
  List<String>? preContext;
  List<String>? postContext;
  bool? inApp;

  SentryStackFrame({
    this.filename,
    this.function,
    this.module,
    this.lineno,
    this.colno,
    this.absPath,
    this.contextLine,
    this.preContext,
    this.postContext,
    this.inApp,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (filename != null) {
      json['filename'] = filename!;
    }
    if (function != null) {
      json['function'] = function!;
    }
    if (module != null) {
      json['module'] = module!;
    }
    if (lineno != null) {
      json['lineno'] = lineno!;
    }
    if (colno != null) {
      json['colno'] = colno!;
    }
    if (absPath != null) {
      json['abs_path'] = absPath!;
    }
    if (contextLine != null) {
      json['context_line'] = contextLine!;
    }
    if (preContext != null) {
      json['pre_context'] = preContext!;
    }
    if (postContext != null) {
      json['post_context'] = postContext!;
    }
    if (inApp != null) {
      json['in_app'] = inApp!;
    }
    return json;
  }
}
