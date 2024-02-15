import 'package:bitlabs/bitlabs.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BitLabsWidget extends StatelessWidget {
  final String html;
  final WidgetType type;
  late final WebViewController controller;

  BitLabsWidget(
      {Key? key,
      required String token,
      required String uid,
      this.type = WidgetType.simple})
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
                window.bitlabsSDK.showWidget("#widget", "${type.name}", {
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
        super(key: key) {
    controller = WebViewController()
      ..setBackgroundColor(Colors.transparent)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadHtmlString(html, baseUrl: 'https://sdk.bitlabs.ai/');
  }

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case WidgetType.simple:
        return Align(
          alignment: Alignment.topCenter,
          child: SizedBox.fromSize(
            size: const Size(280, 130),
            child: WebViewWidget(controller: controller),
          ),
        );
      case WidgetType.compact:
        return Align(
          alignment: Alignment.topCenter,
          child: SizedBox.fromSize(
            size: const Size(250, 72),
            child: WebViewWidget(controller: controller),
          ),
        );
      case WidgetType.fullWidth:
        return SizedBox.fromSize(
          size: const Size(double.infinity, 57),
          child: WebViewWidget(controller: controller),
        );
      case WidgetType.leaderboard:
        return WebViewWidget(controller: controller);
      default:
        return const SizedBox.shrink();
    }
  }
}
