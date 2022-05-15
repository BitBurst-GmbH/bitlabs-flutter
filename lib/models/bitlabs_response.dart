import 'dart:convert';

import 'package:bitlabs/models/check_surveys_response.dart';

import 'bitlabs_error.dart';

class BitLabsResponse {
  final CheckSurveysResponse? data;
  final BitLabsError? error;
  final String status;
  final String traceId;

  BitLabsResponse.fromJson(Map<String, dynamic> json)
      : data = json.containsKey('data')
            ? CheckSurveysResponse(json['data'])
            : null,
        error = json.containsKey('error') ? BitLabsError(json['error']) : null,
        status = json['status'],
        traceId = json['trace_id'];

  Map<String, dynamic> toJson() =>
      {'data': data, 'error': error, 'status': status, 'trace_id': traceId};

  @override
  String toString() => jsonEncode(this);
}
