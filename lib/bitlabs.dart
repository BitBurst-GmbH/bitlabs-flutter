library bitlabs;

import 'dart:developer';
import 'package:bitlabs/api/bitlabs_repository.dart';
import 'package:bitlabs/models/Survey.dart';
import 'package:bitlabs/utilities/helpers.dart';
import 'package:bitlabs/web_widget.dart';
import 'package:flutter/material.dart';

class BitLabs {
  static final BitLabs instance = BitLabs._();

  String _token = "";
  String _uid = "";

  Map<String, dynamic> _tags = {};

  void Function(double) _onReward = (double payout) {};

  BitLabsRepository? _bitLabsRepository;

  BitLabs._();

  void init(String token, String uid) {
    _token = token;
    _uid = uid;
    _bitLabsRepository = BitLabsRepository(token, uid);
  }

  void setTags(Map<String, dynamic> tags) {
    _tags = tags;
  }

  void addTag(String key, var value) {
    _tags[key] = value;
  }

  void setOnReward(void Function(double) onReward) {
    _onReward = onReward;
  }

  void checkSurveys(void Function(bool?) onResponse) => _ifInitialised(() {
        _bitLabsRepository
            ?.checkSurveys((hasSurveys) => onResponse(hasSurveys));
      });

  void getSurveys(void Function(List<Survey>?) onResponse) =>
      _ifInitialised(() {
        _bitLabsRepository?.getSurveys((surveys) => onResponse(surveys));
      });

  void leaveSurvey(String networkId, String surveyId, String reason) {
    _bitLabsRepository?.leaveSurvey(networkId, surveyId, reason);
  }

  void launchOfferWall(BuildContext context) => _ifInitialised(() {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) {
            return WebWidget(
              url: offerWallUrl(_token, _uid, _tags),
              onReward: _onReward,
            );
          }),
        );
      });

  void _ifInitialised(Function block) {
    if (_bitLabsRepository == null) {
      log('[BitLabs] Trying to use BitLabs without initialising it!'
          'You should initialise BitLabs first! Call BitLabs::init()');
      return;
    }
    block();
  }
}
