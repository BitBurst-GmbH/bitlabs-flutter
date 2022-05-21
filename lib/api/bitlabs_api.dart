import 'dart:convert';
import 'dart:io';

import 'package:bitlabs/utilities.dart';
import 'package:http/http.dart';

class BitLabsApi {
  final Map<String, String> _headers;

  BitLabsApi(String token, String uid)
      : _headers = {'X-Api-Token': token, 'X-User-Id': uid};

  Future<Response> checkSurveys() => get(_url('check'), headers: _headers);

  // TODO: Add query parameter 'sdk'='FLUTTER'
  Future<Response> getActions() =>
      get(_url('actions', {'os': platform()}), headers: _headers);

  Future<Response> leaveSurveys(
          String networkId, String surveyId, String reason) =>
      post(_url('networks/$networkId/surveys/$surveyId/leave'),
          headers: {..._headers}, body: jsonEncode({'reason': reason}));
}

Uri _url(String path, [Map? query]) => Uri.https(
    'api.bitlabs.ai', 'v1/client/$path', {...?query, 'platform': 'MOBILE'});
