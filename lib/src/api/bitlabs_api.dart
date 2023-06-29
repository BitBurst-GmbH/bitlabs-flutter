import 'dart:convert';

import 'package:http/http.dart';

import '../utils/helpers.dart';

class BitLabsApi {
  final Map<String, String> _headers;

  BitLabsApi(String token, String uid)
      : _headers = {'X-Api-Token': token, 'X-User-Id': uid};

  Future<Response> checkSurveys() =>
      get(url('v1/client/check'), headers: _headers);

  Future<Response> getSurveys() =>
      get(url('v2/client/surveys', {'os': platform}), headers: _headers);

  Future<Response> getOffers() =>
      get(url('v1/client/offers'), headers: _headers);

  Future<Response> getLeaderboard() =>
      get(url('v1/client/leaderboard'), headers: _headers);

  Future<Response> leaveSurveys(
    String networkId,
    String surveyId,
    String reason,
  ) {
    return post(
      url('v1/client/networks/$networkId/surveys/$surveyId/leave'),
      headers: {..._headers},
      body: jsonEncode({'reason': reason}),
    );
  }

  Future<Response> getAppSettings() =>
      get(url('v1/client/settings/v2'), headers: _headers);

  static Future<Response> getCurrencyIcon(String url) => get(Uri.parse(url));
}
