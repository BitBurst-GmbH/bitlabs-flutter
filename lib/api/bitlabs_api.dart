import 'dart:convert';

import 'package:http/http.dart';

import '../models/bitlabs_response.dart';

class BitLabsApi {
  final Map<String, String> _headers;
  final _url = 'api.bitlabs.ai';

  BitLabsApi(String token, String uid)
      : _headers = {'X-Api-Token': token, 'X-User-Id': uid};

  Future<Response> checkSurveys() =>
      get(Uri.https(_url, 'v1/client/check', {'platform': 'MOBILE'}),
          headers: _headers);
}
