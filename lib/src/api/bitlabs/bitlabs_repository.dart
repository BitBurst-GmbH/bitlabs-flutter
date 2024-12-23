import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../models/bitlabs/bitlabs_response.dart';
import '../../models/bitlabs/get_app_settings_response.dart';
import '../../models/bitlabs/get_leaderboard_response.dart';
import '../../models/bitlabs/get_surveys_response.dart';
import '../../models/bitlabs/serializable.dart';
import '../../models/bitlabs/survey.dart';
import 'bitlabs_service.dart';

/// The point of communication between the data and [BitLabs].
class BitLabsRepository {
  final BitLabsService _bitLabsService;

  BitLabsRepository(BitLabsService bitLabsApi) : _bitLabsService = bitLabsApi;

  void getSurveys(void Function(List<Survey>) onResponse,
      void Function(Exception) onFailure) async {
    try {
      final response = await _bitLabsService.getSurveys();

      final body = BitLabsResponse<GetSurveysResponse>.fromJson(
          jsonDecode(response.body), (data) => GetSurveysResponse(data!));
      final error = body.error;
      if (error != null) {
        onFailure(Exception('${error.details.http} - ${error.details.msg}'));
        return;
      }

      final restriction = body.data?.restrictionReason;
      if (restriction != null) {
        onFailure(Exception('Restriction ${restriction.prettyPrint()}'));
        return;
      }

      final surveys = body.data?.surveys ?? [];
      onResponse(surveys);
    } catch (e) {
      onFailure(Exception('Error - ${e.toString()}'));
    }
  }

  void getLeaderboard(void Function(GetLeaderboardResponse) onResponse,
      void Function(Exception) onFailure) async {
    try {
      final response = await _bitLabsService.getLeaderboard();
      final body = BitLabsResponse<GetLeaderboardResponse>.fromJson(
          jsonDecode(response.body), (data) => GetLeaderboardResponse(data!));

      final error = body.error;
      if (error != null) {
        onFailure(Exception('[BitLabs] GetLeaderboard ${error.details.http}:'
            ' ${error.details.msg}'));
        return;
      }

      final leaderboard = body.data;
      if (leaderboard != null) onResponse(leaderboard);
    } catch (e) {
      onFailure(Exception('Error - ${e.toString()}'));
    }
  }

  void leaveSurvey(
      String clickId,
      String reason,
      void Function(String) onResponse,
      void Function(Exception) onFailure) async {
    try {
      final response = await _bitLabsService.updateClick(clickId, reason);
      final body = BitLabsResponse<Serializable>.fromJson(
          jsonDecode(response.body), (data) => Serializable());

      final error = body.error;
      if (error != null) {
        onFailure(Exception('[BitLabs] LeaveSurvey ${error.details.http}:'
            ' ${error.details.msg}'));
        return;
      }

      onResponse('[BitLabs] LeaveSurvey Successful');
    } catch (e) {
      onFailure(Exception('Error - ${e.toString()}'));
    }
  }

  void getAppSettings(void Function(GetAppSettingsResponse) onResponse,
      void Function(Exception) onFailure) async {
    try {
      final response = await _bitLabsService.getAppSettings();
      final body = BitLabsResponse<GetAppSettingsResponse>.fromJson(
          jsonDecode(response.body), (data) => GetAppSettingsResponse(data!));

      final error = body.error;
      if (error != null) {
        onFailure(Exception('${error.details.http} - ${error.details.msg}'));
        return;
      }

      if (body.data != null) onResponse(body.data!);
    } catch (e) {
      onFailure(Exception('Error - ${e.toString()}'));
    }
  }

  static void getCurrencyIcon(String url, void Function(Widget) onResponse,
      void Function(Exception) onFailure) async {
    final response = await BitLabsService.getCurrencyIcon(url);

    if (response.reasonPhrase != 'OK') {
      onFailure(Exception('[BitLabs] GetCurrencyIcon ${response.statusCode}:'
          ' ${response.reasonPhrase}'));
      return;
    }

    if (response.headers['content-type'] == 'image/svg+xml') {
      onResponse(SvgPicture.string(response.body, fit: BoxFit.contain));
    } else {
      onResponse(Image.memory(response.bodyBytes, fit: BoxFit.contain));
    }
  }
}
