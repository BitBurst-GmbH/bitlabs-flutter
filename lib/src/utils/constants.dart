// ignore_for_file: constant_identifier_names

const OFFERWALL_URL = 'https://web.bitlabs.ai';

const ADGATE_SUPPORT_URL = 'https://wall.adgaterewards.com/contact/';

const POST_MESSAGE_SCRIPT = '''
  if (!window.isEventListenerAdded) {
    window.addEventListener('message', function(event) {
      window.FlutterWebView.postMessage(JSON.stringify(event.data));
    });
    window.isEventListenerAdded = true;
  }
''';
