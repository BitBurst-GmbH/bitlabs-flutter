import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../bitlabs.dart';

@Deprecated('This will be removed in a future major.')
class BitLabsWidget extends StatelessWidget {
  final String html;
  final WidgetType type;
  late final WebViewController controller;

  BitLabsWidget(
      {super.key,
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
        <script
          type="module"
          src="https://sdk.bitlabs.ai/bitlabs-sdk-v1.0.0.js"
        ></script>
        <link
          rel="stylesheet"
          href="https://sdk.bitlabs.ai/bitlabs-sdk-v1.0.0.css"
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
  ''' {
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
    required this.size,
    required this.controller,
  });

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
