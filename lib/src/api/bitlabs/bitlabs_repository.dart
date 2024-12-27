import 'dart:convert';

import 'package:bitlabs/src/models/sentry/sentry_manager.dart';
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
        final exception =
            Exception('${error.details.http} - ${error.details.msg}');
        SentryManager().captureEvent(exception, StackTrace.current);
        onFailure(exception);
        return;
      }

      final restriction = body.data?.restrictionReason;
      if (restriction != null) {
        final exception = Exception('Restriction ${restriction.prettyPrint()}');
        SentryManager().captureEvent(exception, StackTrace.current);
        onFailure(exception);
        return;
      }

      final surveys = body.data?.surveys ?? [];
      onResponse(surveys);
    } catch (e, stackTrace) {
      final exception = Exception('Error - ${e.toString()}');
      SentryManager().captureEvent(exception, stackTrace);
      onFailure(exception);
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
        final exception = Exception(
            '[BitLabs] GetLeaderboard ${error.details.http}: ${error.details.msg}');
        SentryManager().captureEvent(exception, StackTrace.current);
        onFailure(exception);
        return;
      }

      final leaderboard = body.data;
      if (leaderboard != null) onResponse(leaderboard);
    } catch (e, stackTrace) {
      final exception = Exception('Error - ${e.toString()}');
      SentryManager().captureEvent(exception, stackTrace);
      onFailure(exception);
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
        final exception = Exception(
            '[BitLabs] LeaveSurvey ${error.details.http}:${error.details.msg}');
        SentryManager().captureEvent(exception, StackTrace.current);
        onFailure(exception);
        return;
      }

      onResponse('[BitLabs] LeaveSurvey Successful');
    } catch (e, stackTrace) {
      final exception = Exception('Error - ${e.toString()}');
      SentryManager().captureEvent(exception, stackTrace);
      onFailure(exception);
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
        final exception = Exception(
            '[BitLabs] GetAppSettings ${error.details.http}:${error.details.msg}');
        SentryManager().captureEvent(exception, StackTrace.current);
        onFailure(exception);
        return;
      }

      if (body.data != null) onResponse(body.data!);
    } catch (e, stackTrace) {
      final exception = Exception('Error - ${e.toString()}');
      SentryManager().captureEvent(exception, stackTrace);
      onFailure(exception);
    }
  }

  static void getCurrencyIcon(String url, void Function(Widget) onResponse,
      void Function(Exception) onFailure) async {
    final response = await BitLabsService.getCurrencyIcon(url);

    if (response.reasonPhrase != 'OK') {
      final exception =
          Exception('[BitLabs] GetCurrencyIcon ${response.statusCode}:'
              ' ${response.reasonPhrase}');
      SentryManager().captureEvent(exception, StackTrace.current);
      onFailure(exception);
      return;
    }

    if (response.headers['content-type'] == 'image/svg+xml') {
      onResponse(SvgPicture.string(response.body, fit: BoxFit.contain));
    } else {
      onResponse(Image.memory(response.bodyBytes, fit: BoxFit.contain));
    }
  }
}
