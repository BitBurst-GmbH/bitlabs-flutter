import 'dart:convert';
import 'dart:developer';

import 'package:bitlabs/src/utils/helpers.dart';

import '../models/get_offers_response.dart';
import '../models/survey.dart';
import '../models/bitlabs_response.dart';
import '../models/check_surveys_response.dart';
import '../models/get_actions_response.dart';
import '../models/serializable.dart';
import 'bitlabs_api.dart';

/// The point of communication between the data and [BitLabs].
class BitLabsRepository {
  final BitLabsApi _bitLabsApi;

  BitLabsRepository(String token, String uid)
      : _bitLabsApi = BitLabsApi(token, uid);

  void checkSurveys(void Function(bool?) onResponse) async {
    var response = await _bitLabsApi.checkSurveys();
    var body = BitLabsResponse<CheckSurveysResponse>.fromJson(
        jsonDecode(response.body), (data) => CheckSurveysResponse(data!));

    var error = body.error;
    if (error != null) {
      log('[BitLabs] CheckSurveys ${error.details.http}:'
          ' ${error.details.msg}');
      onResponse(null);
      return;
    }

    onResponse(body.data?.hasSurveys);
  }

  void getHasOffers(void Function(bool?) onResponse) async {
    var response = await _bitLabsApi.getOffers();
    var body = BitLabsResponse<GetOffersResponse>.fromJson(
        jsonDecode(response.body), (data) => GetOffersResponse(data!));

    var error = body.error;
    if (error != null) {
      log('[BitLabs] GetOffers ${error.details.http}: '
          ' ${error.details.msg}');
      onResponse(null);
      return;
    }

    onResponse(body.data?.offers.isNotEmpty);
  }

  void getSurveys(void Function(List<Survey>?) onResponse) async {
    var response = await _bitLabsApi.getActions();
    var body = BitLabsResponse<GetActionsResponse>.fromJson(
        jsonDecode(response.body), (data) => GetActionsResponse(data!));

    var error = body.error;
    if (error != null) {
      log('[BitLabs] GetSurveys ${error.details.http}:'
          ' ${error.details.msg}');
      onResponse(null);
      return;
    }

    var surveys = body.data?.surveys ?? [];

    onResponse(surveys.isNotEmpty ? surveys : randomSurveys());
  }

  void leaveSurvey(String networkId, String surveyId, String reason) async {
    var response = await _bitLabsApi.leaveSurveys(networkId, surveyId, reason);
    var body = BitLabsResponse<Serializable>.fromJson(
        jsonDecode(response.body), (data) => Serializable());

    var error = body.error;
    if (error != null) {
      log('[BitLabs] LeaveSurvey ${error.details.http}:'
          ' ${error.details.msg}');
      return;
    }

    log('[BitLabs] LeaveSurvey Successful');
  }
}
