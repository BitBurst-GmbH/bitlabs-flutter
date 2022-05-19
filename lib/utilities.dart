import 'dart:io' show Platform;

String platform() => Platform.isAndroid ? 'ANDROID' : 'IOS';

// TODO: Add sdk='FLUTTER' parameter
String offerWallUrl(String token, String uid, Map<String, dynamic> tags) =>
    Uri.https('web.bitlabs.ai', '', {
      'token': token,
      'uid': uid,
      ...tags,
    }).toString();
