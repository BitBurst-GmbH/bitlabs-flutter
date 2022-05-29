class ErrorDetails {
  final String http;
  final String msg;

  ErrorDetails(Map<String, dynamic> json)
      : http = json["http"],
        msg = json["msg"];

  Map<String, String> toJson() => {'http': http, 'msg': msg};
}
