import 'dart:convert';

import 'package:bitlabs/utilities.dart';
import 'package:http/http.dart';

class BitLabsApi {
  final Map<String, String> _headers;
  final _url = 'api.bitlabs.ai';

  BitLabsApi(String token, String uid)
      : _headers = {'X-Api-Token': token, 'X-User-Id': uid};

  Future<Response> checkSurveys() =>
      get(Uri.https(_url, 'v1/client/check', {'platform': 'MOBILE'}),
          headers: _headers);

  // TODO: Add query parameter 'sdk'='FLUTTER'
  Future<Response> getActions() => get(
      Uri.https(
          _url, 'v1/client/actions', {'platform': 'MOBILE', 'os': platform()}),
      headers: _headers);

  Future<Response> leaveSurveys(
          String networkId, String surveyId, String reason) =>
      post(
          Uri.https(
              _url, '/v1/client/networks/$networkId/surveys/$surveyId/leave'),
          headers: {..._headers, 'content-type': 'application/json'},
          body: jsonEncode({'reason': reason}));
}
