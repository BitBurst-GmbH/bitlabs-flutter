// ignore_for_file: constant_identifier_names

const BASE_URL = 'web.bitlabs.ai';
const OFFERWALL_URL = 'https://$BASE_URL/';

const POST_MESSAGE_SCRIPT = '''
  if (!window.isEventListenerAdded) {
    window.addEventListener('message', function(event) {
      window.FlutterWebView.postMessage(JSON.stringify(event.data));
    });
    window.isEventListenerAdded = true;
  }
''';
