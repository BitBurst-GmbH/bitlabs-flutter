import 'package:bitlabs/bitlabs.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../models/bitlabs/widget_type.dart';

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
    if (type == WidgetType.leaderboard) {
      // GestureDetector not used here because of conflict with WebView scrolling
      return WebViewWidget(controller: controller);
    }

    return _SizeableWebView(
      size: _getSizeByType(type),
      controller: controller,
    );
  }

  _getSizeByType(WidgetType type) {
    switch (type) {
      case WidgetType.simple:
        return const Size(300, 135);
      case WidgetType.compact:
        return const Size(260, 80);
      case WidgetType.fullWidth:
        return const Size(double.infinity, 57);
      default:
        return const Size(0, 0);
    }
  }
}

class _SizeableWebView extends StatelessWidget {
  final Size size;
  final WebViewController controller;

  const _SizeableWebView({
    Key? key,
    required this.size,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: SizedBox.fromSize(
        size: size,
        child: GestureDetector(
          onTapDown: (tap) => BitLabs.instance.launchOfferWall(context),
          child: WebViewWidget(controller: controller),
        ),
      ),
    );
  }
}
