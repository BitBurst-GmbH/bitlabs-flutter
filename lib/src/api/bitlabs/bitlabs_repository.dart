import 'dart:convert';

import 'package:bitlabs/src/models/sentry/sentry_manager.dart';

import '../../models/bitlabs/bitlabs_response.dart';
import '../../models/bitlabs/get_app_settings_response.dart';
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

  void getAppSettings(
      String token,
      void Function(GetAppSettingsResponse) onResponse,
      void Function(Exception) onFailure) async {
    try {
      final response = await _bitLabsService.getAppSettings(
        'https://dashboard.bitlabs.ai/api/public/v1/apps/$token',
      );
      final body = GetAppSettingsResponse(jsonDecode(response.body));

      onResponse(body);
    } catch (e, stackTrace) {
      final exception = Exception('Error - ${e.toString()}');
      SentryManager().captureEvent(exception, stackTrace);
      onFailure(exception);
    }
  }
}
