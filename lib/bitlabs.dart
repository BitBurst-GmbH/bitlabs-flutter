library bitlabs;

import 'dart:convert';
import 'dart:developer';
import 'dart:ffi';
import 'package:bitlabs/models/bitlabs_response.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class BitLabs {
  static final BitLabs instance = BitLabs._();

  String _token = "";
  String _uid = "";

  Map _tags = {};

  Function(Float) _onReward = (Float payout) {};

  // TODO: BitLabs API Reference

  BitLabs._();

  void init(String token, String uid) {
    _token = token;
    _uid = uid;
  }

  void setTags(Map tags) {
    _tags = tags;
  }

  void addTag(String key, var value) {
    _tags[key] = value;
  }

  void setOnReward(Function(Float) onReward) {
    _onReward = onReward;
  }

  void checkSurveys(Function(bool) onResponse) => _ifInitialised(() async {
        var response = await http.get(
            Uri.parse('https://api.bitlabs.ai/v1/client/check?platform=MOBILE'),
            headers: {'X-Api-Token': _token, 'X-User-Id': _uid});

        var data = BitLabsResponse.fromJson(jsonDecode(response.body));
        if (data.data == null) {
          print('[BitLabs] CheckSurveys ${data.error?.details.http}:'
              ' ${data.error?.details.msg}');
        } else {
          onResponse(data.data!.hasSurveys);
        }
      });

  void _ifInitialised(Function block) {
    if (_token.isEmpty && _uid.isEmpty) {
      if (kDebugMode) {
        print('[BitLabs] Trying to use the BitLabs without initialising it!'
            'You should initialise BitLabs first! Call BitLabs::init()');
      }
      return;
    }
    block();
  }
}
