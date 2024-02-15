import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BitLabsWidget extends StatelessWidget {
  final String html;

  const BitLabsWidget({Key? key, required String token, required String uid})
      : html = '''
    <!DOCTYPE html>
    <html lang="en">
      <head>
        <meta charset="utf-8" />
        <meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no' />
        <style>
          html,
          body,
          #widget {
            height: 100%;
            margin: 0%;
          }
        </style>
        <script src="https://sdk.bitlabs.ai/bitlabs-sdk-v0.0.2.js"></script>
        <link
          rel="stylesheet"
          href="https://sdk.bitlabs.ai/bitlabs-sdk-v0.0.2.css"
        />
        <title>Leaderboard</title>
      </head>
      <body>
        <div id="widget"></div>

        <script>
          function initSDK() {
            window.bitlabsSDK
              .init("$token", "$uid")
              .then(() => {
                window.bitlabsSDK.showWidget("#widget", "leaderboard", {
                  onClick: () => {},
                });

                document.removeEventListener("DOMContentLoaded", this.initSDK);
              });
          }

          document.addEventListener("DOMContentLoaded", this.initSDK);
        </script>
      </body>
    </html>
  ''',
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: WebViewWidget(
        controller: WebViewController()
          ..setBackgroundColor(Colors.transparent)
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..loadHtmlString(html, baseUrl: 'https://sdk.bitlabs.ai/'),
      ),
    );
  }
}
