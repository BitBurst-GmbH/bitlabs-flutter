import 'dart:convert';

import 'package:http/http.dart';

import '../utils/helpers.dart';

class BitLabsApi {
  final Map<String, String> _headers;

  BitLabsApi(String token, String uid)
      : _headers = {'X-Api-Token': token, 'X-User-Id': uid};

  Future<Response> checkSurveys() => get(url('check'), headers: _headers);

  Future<Response> getActions() =>
      get(url('actions', {'os': platform}), headers: _headers);

  Future<Response> getOffers() => get(url('offers'), headers: _headers);

  Future<Response> leaveSurveys(
    String networkId,
    String surveyId,
    String reason,
  ) {
    return post(
      url('networks/$networkId/surveys/$surveyId/leave'),
      headers: {..._headers},
      body: jsonEncode({'reason': reason}),
    );
  }
}
