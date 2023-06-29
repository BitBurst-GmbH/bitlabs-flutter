import 'dart:convert';

import 'package:http/http.dart';

import '../utils/helpers.dart';

class BitLabsApi {
  final Map<String, String> _headers;

  BitLabsApi(String token, String uid)
      : _headers = {'X-Api-Token': token, 'X-User-Id': uid};

  Future<Response> getSurveys() =>
      get(url('v2/client/surveys', {'os': platform}), headers: _headers);

  Future<Response> getOffers() =>
      get(url('v2/client/offers'), headers: _headers);

  Future<Response> getLeaderboard() =>
      get(url('v1/client/leaderboard'), headers: _headers);

  Future<Response> updateClick(
    String clickId,
    String reason,
  ) {
    return post(url('v2/client/clicks/$clickId'),
        headers: {..._headers},
        body: jsonEncode({
          'leave_survey': {'reason': reason}
        }));
  }

  Future<Response> getAppSettings() =>
      get(url('v1/client/settings/v2'), headers: _headers);

  static Future<Response> getCurrencyIcon(String url) => get(Uri.parse(url));
}
