import 'dart:convert';

import 'package:http/http.dart';

import '../../utils/helpers.dart';
import '../../utils/user_agent.dart';

class BitLabsService {
  final Map<String, String> _headers;

  BitLabsService(String token, String uid)
      : _headers = {
          'X-Api-Token': token,
          'X-User-Id': uid,
        } {
    getUserAgent().then((value) => _headers['User-Agent'] = value);
  }

  Future<Response> getSurveys() => get(
      url('v2/client/surveys', {
        'os': system,
        'sdk': 'FLUTTER',
      }),
      headers: _headers);

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

  Future<Response> getAppSettings(String url) => get(Uri.parse(url));

  static Future<Response> getCurrencyIcon(String url) => get(Uri.parse(url));
}
