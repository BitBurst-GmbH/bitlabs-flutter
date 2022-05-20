import 'dart:convert';
import 'dart:developer';

import 'package:bitlabs/api/bitlabs_api.dart';
import 'package:bitlabs/models/Survey.dart';
import 'package:bitlabs/models/check_surveys_response.dart';
import 'package:bitlabs/models/get_actions_response.dart';

import '../models/bitlabs_error.dart';
import '../models/bitlabs_response.dart';

class BitLabsRepository {
  final BitLabsApi _bitLabsApi;

  BitLabsRepository(String token, String uid)
      : _bitLabsApi = BitLabsApi(token, uid);

  void checkSurveys(void Function(bool?) onResponse) async {
    var response = await _bitLabsApi.checkSurveys();
    var body = BitLabsResponse<CheckSurveysResponse>.fromJson(
        jsonDecode(response.body));

    var error = body.error;
    if (error != null) {
      log('[BitLabs] CheckSurveys ${error.details.http}:'
          ' ${error.details.msg}');
      onResponse(null);
      return;
    }

    onResponse(body.data.hasSurveys);
  }

  void getSurveys(void Function(List<Survey>?) onResponse) async {
    var response = await _bitLabsApi.getActions();
    var body =
        BitLabsResponse<GetActionsResponse>.fromJson(jsonDecode(response.body));

    var error = body.error;
    if (error != null) {
      log('[BitLabs] GetSurveys ${error.details.http}:'
          ' ${error.details.msg}');
      onResponse(null);
      return;
    }

    onResponse(body.data.surveys);
  }

  void leaveSurvey(String networkId, String surveyId, String reason) async {
    var response = await _bitLabsApi.leaveSurveys(networkId, surveyId, reason);
    var body = BitLabsResponse<void>.fromJson(jsonDecode(response.body));

    var error = body.error;
    if (error != null) {
      log('[BitLabs] LeaveSurvey ${error.details.http}:'
          ' ${error.details.msg}');
      return;
    }

    log('[BitLabs] LeaveSurvey Successful');
  }
}
