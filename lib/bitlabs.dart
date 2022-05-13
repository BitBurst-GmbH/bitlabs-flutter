library bitlabs;

import 'dart:ffi';
import 'package:flutter/foundation.dart';

class BitLabs {
  static final BitLabs instance = BitLabs._();

  String _token = "";
  String _uid = "";

  Map _tags = {};

  Function(Float) _onReward = (Float payout) {};

  // BitLabs API Reference

  BitLabs._();

  init(String token, String uid) {
    _token = token;
    _uid = uid;
  }

  setTags(Map tags) {
    _tags = tags;
  }

  addTag(String key, var value) {
    _tags[key] = value;
  }

  _ifInitialised(Function block) {
    if (_token.isEmpty && _uid.isEmpty) {
      if (kDebugMode) {
        print("[BitLabs] You should initialise BitLabs first! "
            "Call BitLabs::init()");
      }
      return;
    }
    block();
  }
}
