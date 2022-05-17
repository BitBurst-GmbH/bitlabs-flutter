import 'dart:convert';

import 'package:bitlabs/models/check_surveys_response.dart';
import 'package:bitlabs/models/get_actions_response.dart';

import 'bitlabs_error.dart';

class BitLabsResponse<T> {
  final dynamic data;
  final BitLabsError? error;
  final String status;
  final String traceId;

  BitLabsResponse.fromJson(Map<String, dynamic> json)
      : data = json.containsKey('data')
            ? (T == CheckSurveysResponse
                ? CheckSurveysResponse(json['data'])
                : GetActionsResponse(json['data']))
            : null,
        error = json.containsKey('error') ? BitLabsError(json['error']) : null,
        status = json['status'],
        traceId = json['trace_id'];

  Map<String, dynamic> toJson() =>
      {'data': data, 'error': error, 'status': status, 'trace_id': traceId};

  @override
  String toString() => jsonEncode(this);
}
