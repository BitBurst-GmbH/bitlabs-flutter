library bitlabs;

import 'dart:developer';
import 'dart:io';
import 'package:advertising_id/advertising_id.dart';
import 'package:bitlabs/src/models/widget_type.dart';
import 'package:bitlabs/src/ui/survey_widget.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'src/api/bitlabs_repository.dart';
import 'src/models/survey.dart';
import 'src/utils/helpers.dart';
import 'src/ui/web_widget.dart';

export 'src/models/survey.dart';
export 'src/models/details.dart';
export 'src/ui/compact_survey_widget.dart';
export 'src/models/category.dart';
export 'src/ui/full_width_survey_widget.dart';
export 'src/utils/localization.dart' show LocalizationDelegate;

/// The main class including all the library functions to use in your code.
///
/// This is a singleton object, so you'll have one instance throughout the whole
/// main process(app lifecycle).
class BitLabs {
  static final BitLabs instance = BitLabs._();

  String _uid = '';
  String _adId = '';
  String _token = '';
  bool _hasOffers = false;
  Map<String, dynamic> _tags = {};
  Color _widgetColor = Colors.blueAccent;
  Color _headerColor = Colors.blueAccent;

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
    _bitLabsRepository = BitLabsRepository(token, uid);

    _bitLabsRepository?.getAppSettings(
        (visual){
          _widgetColor = colorFromHex(visual.surveyIconColor);
          _headerColor = colorFromHex(visual.navigationColor);},
        (error) => log(error.toString()));

    _getHasOffers();
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

  /// Determines whether the user can perform an action in the OfferWall
  /// (either opening a survey or answering qualifications) and then executes [onResponse].
  ///
  /// If you want to perform background checks if surveys are available, this is the best option.
  ///
  /// The boolean parameter in [onResponse] is `true` if an action can be performed
  /// and `false` otherwise. If it's `null`,then there has been an internal error
  /// which is most probably logged with 'BitLabs' as a tag.
  void checkSurveys(
          void Function(bool) onResponse, void Function(Exception) onFailure) =>
      _ifInitialised(() {
        _bitLabsRepository?.checkSurveys(onResponse, onFailure);
      });

  /// Fetches a list of surveys the user can open.
  ///
  /// The [onResponse] callback executes when a response is received.
  /// Its parameter is the list of surveys. If it's `null`, then there has been an internal error
  /// which is most probably logged with 'BitLabs' as a tag.
  void getSurveys(void Function(List<Survey>) onResponse,
          void Function(Exception) onFailure) =>
      _ifInitialised(
          () => _bitLabsRepository?.getSurveys(onResponse, onFailure));

  List<SurveyWidget> getSurveyWidgets(List<Survey> surveys) {
    return List.generate(surveys.length, (index) {
      final survey = surveys[index];
      return SurveyWidget(
        type: WidgetType.fullWidth,
        color: _widgetColor,
        reward: survey.value,
        rating: survey.rating,
        loi: '${survey.loi.toStringAsFixed(2)} minutes',
      );
    });
  }

  void leaveSurvey(String networkId, String surveyId, String reason) =>
      _bitLabsRepository?.leaveSurvey(networkId, surveyId, reason);

  /// Launches the OfferWall from the [context] you pass.
  ///
  /// On iOS, if there are Offers available, the Offerwall will be launched in
  /// the external browser.
  void launchOfferWall(BuildContext context) => _ifInitialised(() {
        final url = offerWallUrl(_token, _uid, _adId, _tags);

        if (Platform.isIOS && _hasOffers) {
          launchUrlString(url, mode: LaunchMode.externalApplication);
          return;
        }

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) {
            return WebWidget(
              url: url,
              color: _headerColor,
              onReward: _onReward,
            );
          }),
        );
      });

  void _getHasOffers() =>
      _bitLabsRepository?.getHasOffers((hasOffers) => _hasOffers = hasOffers);

  void _getAdId([bool requestTrackingAuthorization = false]) async {
    try {
      _adId = await AdvertisingId.id(requestTrackingAuthorization) ?? '';
      log("[BitLabs] $_adId");
    } on Exception catch (e) {
      log("[BitLabs] Couldn't get adID: $_adId ~ Reason: $e)");
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
