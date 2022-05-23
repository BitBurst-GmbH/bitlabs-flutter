import 'dart:convert';

import 'package:bitlabs/models/serializable.dart';

import 'bitlabs_error.dart';

class BitLabsResponse<T extends Serializable> {
  final T? data;
  final BitLabsError? error;
  final String status;
  final String traceId;

  BitLabsResponse.fromJson(
      Map<String, dynamic> json, T Function(Map<String, dynamic>?) create)
      : data = json.containsKey('data') ? create(json['data']) : null,
        error = json.containsKey('error') ? BitLabsError(json['error']) : null,
        status = json['status'],
        traceId = json['trace_id'];

  Map<String, dynamic> toJson() =>
      {'data': data, 'error': error, 'status': status, 'trace_id': traceId};

  @override
  String toString() => jsonEncode(this);
}
