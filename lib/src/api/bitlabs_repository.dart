import 'dart:convert';
import 'dart:developer';

import 'package:bitlabs/src/models/get_app_settings_response.dart';
import 'package:bitlabs/src/models/visual.dart';
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

  void checkSurveys(void Function(bool) onResponse,
      void Function(Exception) onFailure) async {
    final response = await _bitLabsApi.checkSurveys();
    final body = BitLabsResponse<CheckSurveysResponse>.fromJson(
        jsonDecode(response.body), (data) => CheckSurveysResponse(data!));

    final error = body.error;
    if (error != null) {
      onFailure(Exception('${error.details.http} - ${error.details.msg}'));
      return;
    }

    final hasSurveys = body.data?.hasSurveys;
    if (hasSurveys != null) onResponse(hasSurveys);
  }

  void getHasOffers(void Function(bool) onResponse) async {
    final response = await _bitLabsApi.getOffers();
    final body = BitLabsResponse<GetOffersResponse>.fromJson(
        jsonDecode(response.body), (data) => GetOffersResponse(data!));

    final error = body.error;
    if (error != null) {
      log('[BitLabs] GetOffers ${error.details.http}: '
          ' ${error.details.msg}');
      onResponse(false);
      return;
    }

    final offers = body.data?.offers;
    if (offers != null) onResponse(offers.isNotEmpty);
  }

  void getSurveys(void Function(List<Survey>) onResponse,
      void Function(Exception) onFailure) async {
    final response = await _bitLabsApi.getActions();
    final body = BitLabsResponse<GetActionsResponse>.fromJson(
        jsonDecode(response.body), (data) => GetActionsResponse(data!));

    final error = body.error;
    if (error != null) {
      onFailure(Exception('${error.details.http} - ${error.details.msg}'));
      return;
    }

    final surveys = body.data?.surveys ?? [];
    onResponse(surveys.isNotEmpty ? surveys : randomSurveys());
  }

  void leaveSurvey(String networkId, String surveyId, String reason) async {
    final response =
        await _bitLabsApi.leaveSurveys(networkId, surveyId, reason);
    final body = BitLabsResponse<Serializable>.fromJson(
        jsonDecode(response.body), (data) => Serializable());

    final error = body.error;
    if (error != null) {
      log('[BitLabs] LeaveSurvey ${error.details.http}:'
          ' ${error.details.msg}');
      return;
    }

    log('[BitLabs] LeaveSurvey Successful');
  }

  void getAppSettings(void Function(Visual) onResponse,
      void Function(Exception) onFailure) async {
    final response = await _bitLabsApi.getAppSettings();
    final body = BitLabsResponse<GetAppSettingsResponse>.fromJson(
        jsonDecode(response.body), (data) => GetAppSettingsResponse(data!));

    final error = body.error;
    if (error != null) {
      onFailure(Exception('${error.details.http} - ${error.details.msg}'));
      return;
    }

    final visual = body.data?.visual;
    if (visual != null) onResponse(visual);
  }
}
