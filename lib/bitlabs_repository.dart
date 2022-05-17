import 'dart:convert';
import 'dart:developer';

import 'package:bitlabs/api/bitlabs_api.dart';
import 'package:bitlabs/models/Survey.dart';
import 'package:bitlabs/models/check_surveys_response.dart';
import 'package:bitlabs/models/get_actions_response.dart';

import 'models/bitlabs_response.dart';

class BitLabsRepository {
  final BitLabsApi _bitLabsApi;

  BitLabsRepository(String token, String uid)
      : _bitLabsApi = BitLabsApi(token, uid);

  void checkSurveys(Function(bool?) onResponse) async {
    var response = await _bitLabsApi.checkSurveys();
    var bitLabsResponse = BitLabsResponse<CheckSurveysResponse>.fromJson(
        jsonDecode(response.body));

    var data = bitLabsResponse.data;
    if (data == null) {
      log('[BitLabs] CheckSurveys ${bitLabsResponse.error?.details.http}:'
          ' ${bitLabsResponse.error?.details.msg}');
      onResponse(null);
      return;
    }

    onResponse(data.hasSurveys);
  }

  void getSurveys(Function(List<Survey>?) onResponse) async {
    var response = await _bitLabsApi.getActions();
    var bitLabsResponse =
        BitLabsResponse<GetActionsResponse>.fromJson(jsonDecode(response.body));

    var data = bitLabsResponse.data as GetActionsResponse?;
    if (data == null) {
      log('[BitLabs] GetSurveys ${bitLabsResponse.error?.details.http}:'
          ' ${bitLabsResponse.error?.details.msg}');
      onResponse(null);
      return;
    }

    onResponse(data.surveys);
  }
}
