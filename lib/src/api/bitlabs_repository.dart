import 'dart:convert';
import 'dart:developer';

import 'package:bitlabs/src/models/get_app_settings_response.dart';
import 'package:bitlabs/src/models/get_leaderboard_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../models/bitlabs_response.dart';
import '../models/get_surveys_response.dart';
import '../models/serializable.dart';
import '../models/survey.dart';
import 'bitlabs_api.dart';

/// The point of communication between the data and [BitLabs].
class BitLabsRepository {
  final BitLabsApi _bitLabsApi;

  BitLabsRepository(String token, String uid)
      : _bitLabsApi = BitLabsApi(token, uid);

  void getSurveys(void Function(List<Survey>) onResponse,
      void Function(Exception) onFailure) async {
    final response = await _bitLabsApi.getSurveys();
    final body = BitLabsResponse<GetSurveysResponse>.fromJson(
        jsonDecode(response.body), (data) => GetSurveysResponse(data!));

    final error = body.error;
    if (error != null) {
      onFailure(Exception('${error.details.http} - ${error.details.msg}'));
      return;
    }

    final surveys = body.data?.surveys ?? [];
    onResponse(surveys);
  }

  void getLeaderboard(void Function(GetLeaderboardResponse) onResponse) async {
    final response = await _bitLabsApi.getLeaderboard();
    final body = BitLabsResponse<GetLeaderboardResponse>.fromJson(
        jsonDecode(response.body), (data) => GetLeaderboardResponse(data!));

    final error = body.error;
    if (error != null) {
      log('[BitLabs] GetLeaderboard ${error.details.http}:'
          ' ${error.details.msg}');
      return;
    }

    final leaderboard = body.data;
    if (leaderboard != null) onResponse(leaderboard);
  }

  void leaveSurvey(String clickId, String reason) async {
    final response = await _bitLabsApi.updateClick(clickId, reason);
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

  void getAppSettings(void Function(GetAppSettingsResponse) onResponse,
      void Function(Exception) onFailure) async {
    final response = await _bitLabsApi.getAppSettings();
    final body = BitLabsResponse<GetAppSettingsResponse>.fromJson(
        jsonDecode(response.body), (data) => GetAppSettingsResponse(data!));

    final error = body.error;
    if (error != null) {
      onFailure(Exception('${error.details.http} - ${error.details.msg}'));
      return;
    }

    if (body.data != null) onResponse(body.data!);
  }

  static void getCurrencyIcon(
      String url, void Function(Widget) onResponse) async {
    final response = await BitLabsApi.getCurrencyIcon(url);

    if (response.reasonPhrase != 'OK') {
      log('[BitLabs] GetCurrencyIcon ${response.statusCode}:'
          ' ${response.reasonPhrase}');
      return;
    }

    if (response.headers['content-type'] == 'image/svg+xml') {
      onResponse(SvgPicture.string(response.body, fit: BoxFit.contain));
    } else {
      onResponse(Image.memory(response.bodyBytes, fit: BoxFit.contain));
    }
  }
}
