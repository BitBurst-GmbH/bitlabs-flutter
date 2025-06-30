library;

import 'dart:developer';
import 'dart:ui';

import 'package:advertising_id/advertising_id.dart';
import 'package:bitlabs/src/models/sentry/sentry_manager.dart';
import 'package:bitlabs/src/utils/extensions.dart';
import 'package:flutter/material.dart';

import 'src/api/bitlabs/bitlabs_service.dart';
import 'src/api/bitlabs/bitlabs_repository.dart';
import 'src/models/bitlabs/get_leaderboard_response.dart';
import 'src/models/bitlabs/survey.dart';
import 'src/utils/notifiers.dart' as notifiers;
import 'src/widgets/bitlabs_offerwall.dart';

export 'src/models/bitlabs/survey.dart';
export 'src/models/bitlabs/category.dart';
export 'src/models/bitlabs/widget_type.dart';
export 'src/utils/localization.dart' show LocalizationDelegate;
export 'src/widgets/bitlabs_offerwall.dart';
export 'src/widgets/bitlabs_widget.dart';

/// The main class including all the library functions to use in your code.
///
/// This is a singleton object, so you'll have one instance throughout the whole
/// main process(app lifecycle).
class BitLabs {
  static final BitLabs instance = BitLabs._();

  String _uid = '';
  String _adId = '';
  String _token = '';
  Map<String, dynamic> _tags = {};
  List<Color> _headerColor = [Colors.blueAccent, Colors.blueAccent];

  BitLabsRepository? _bitLabsRepository;

  void Function(double) _onReward = (double payout) {};

  BitLabs._();

  /// Initialises BitLabs so that it's ready to use.
  ///
  /// This is the essential function. Without it, the library will not function properly.
  /// So make sure you call it before using the library's functions.
  ///
  /// - The [token] is found in your [BitLabs Dashboard](https://dashboard.bitlabs.ai/).
  /// - The [uid] should belong to the current user so that you to keep track of which user got what.
  void init(String token, String uid) {
    _token = token;
    _uid = uid;
    _bitLabsRepository = BitLabsRepository(BitLabsService(token, uid));

    SentryManager().init(token, uid);

    PlatformDispatcher.instance.onError = (error, stack) {
      if (stack.toString().contains('package:bitlabs')) {
        SentryManager().captureEvent(error, stack, isHandled: false);
      }
      return false;
    };

    _bitLabsRepository?.getAppSettings(_token, (settings) {
      final config = settings.configuration;
      final theme = 'light'; // TODO: Implement dark mode

      final surveyIconColor = config
              .firstWhere((c) =>
                  c.internalIdentifier == 'app.visual.$theme.survey_icon_color')
              .value ??
          '';
      notifiers.widgetColor.value = surveyIconColor.colorsFromCSS().isNotEmpty
          ? surveyIconColor.colorsFromCSS()
          : [Colors.blueAccent, Colors.blueAccent];

      final navigationColor = config
              .firstWhere((c) =>
                  c.internalIdentifier == 'app.visual.$theme.navigation_color')
              .value ??
          '';
      _headerColor = navigationColor.colorsFromCSS().isNotEmpty
          ? navigationColor.colorsFromCSS()
          : [Colors.blueAccent, Colors.blueAccent];
    }, (error) => log(error.toString()));

    _getAdId();
  }

  /// **FOR IOS ONLY.** Prompts the user to give Authorization for Tracking.
  ///
  /// If the user allows it, the ad Id will be stored and used for BitLabs Offers.
  /// If the user rejects it nothing will be stored.
  void requestTrackingAuthorization() {
    _getAdId(true);
  }

  /// These will be added as query parameters to the OfferWall Link.
  void setTags(Map<String, dynamic> tags) => _tags = tags;

  /// Adds a new ([key],[value]) pair to [tags]
  Future<void> addTag(String key, var value) async => _tags[key] = value;

  /// Registers a reward callback to be invoked when the OfferWall is exited by the user.
  void setOnReward(void Function(double) onReward) => _onReward = onReward;

  /// Determines whether the user has surveys available.
  ///
  /// The boolean parameter in [onResponse] is `true` if there are surveys available
  /// and `false` otherwise.
  void checkSurveys(
    void Function(bool) onResponse,
    void Function(Exception) onFailure,
  ) =>
      _ifInitialised(() {
        _bitLabsRepository?.getSurveys(
            (surveys) => onResponse(surveys.isNotEmpty), onFailure);
      });

  /// Fetches a list of surveys the user can open.
  ///
  /// The [onResponse] callback executes when a response is received.
  /// Its parameter is the list of surveys.
  void getSurveys(
    void Function(List<Survey>) onResponse,
    void Function(Exception) onFailure,
  ) =>
      _ifInitialised(
        () => _bitLabsRepository?.getSurveys(
            (surveys) => onResponse(surveys), onFailure),
      );

  void getLeaderboard(void Function(GetLeaderboardResponse) onResponse) =>
      _ifInitialised(() {
        _bitLabsRepository?.getLeaderboard(
            onResponse, (error) => log(error.toString()));
      });

  void leaveSurvey(String clickId, String reason) =>
      _bitLabsRepository?.leaveSurvey(
          clickId,
          reason,
          (response) => log('[BitLabs] LeaveSurvey: $response'),
          (error) => log(error.toString()));

  /// Launches the OfferWall from the [context] you pass.
  ///
  /// On iOS, if there are Offers available, the Offerwall will be launched in
  /// the external browser.
  void launchOfferWall(BuildContext context) => _ifInitialised(() {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return BitLabsOfferwall(
            uid: _uid,
            adId: _adId,
            tags: _tags,
            token: _token,
            color: _headerColor,
            onReward: _onReward,
          );
        }));
      });

  void _getAdId([bool requestTrackingAuthorization = false]) async {
    try {
      _adId = await AdvertisingId.id(requestTrackingAuthorization) ?? '';
      log("[BitLabs] adId: $_adId");
    } on Exception catch (e, stacktrace) {
      SentryManager().captureEvent(e, stacktrace);
      log("[BitLabs] Couldn't get adId: $_adId ~ Reason: $e)");
    }
  }

  /// Checks whether [token] and [uid] have been set and aren't blank/empty and
  /// thus [bitLabsRepo] is initialised and executes the [block] accordingly.
  void _ifInitialised(Function block) {
    if (_bitLabsRepository == null) {
      log('[BitLabs] Trying to use BitLabs without initialising it!'
          'You should initialise BitLabs first! Call BitLabs::init()');
      return;
    }
    block();
  }
}
