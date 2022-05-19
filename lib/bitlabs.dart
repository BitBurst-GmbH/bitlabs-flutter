library bitlabs;

import 'dart:developer';
import 'dart:ffi';
import 'package:bitlabs/bitlabs_repository.dart';
import 'package:bitlabs/models/Survey.dart';
import 'package:bitlabs/utilities.dart';
import 'package:bitlabs/webview_offerwall.dart';
import 'package:flutter/material.dart';

class BitLabs {
  static final BitLabs instance = BitLabs._();

  String _token = "";
  String _uid = "";

  Map<String, dynamic> _tags = {};

  Function(Float) _onReward = (Float payout) {};

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

  void setOnReward(Function(Float) onReward) {
    _onReward = onReward;
  }

  void checkSurveys(Function(bool?) onResponse) => _ifInitialised(() {
        _bitLabsRepository
            ?.checkSurveys((hasSurveys) => onResponse(hasSurveys));
      });

  void getSurveys(Function(List<Survey>?) onResponse) => _ifInitialised(() {
        _bitLabsRepository?.getSurveys((surveys) => onResponse(surveys));
      });

  void launchOfferWall(BuildContext context) => _ifInitialised(() {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) {
            return WebWidget(url: offerWallUrl(_token, _uid, _tags));
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
