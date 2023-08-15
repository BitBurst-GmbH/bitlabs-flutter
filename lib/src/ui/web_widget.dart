import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../bitlabs.dart';
import '../utils/helpers.dart';
import '../utils/localization.dart';
import 'styled_text.dart';

/// Launches the Offer Wall in a [WebView].
class WebWidget extends StatefulWidget {
  final String url;
  final String uid;
  final List<Color> color;
  final void Function(double) onReward;

  const WebWidget(
      {Key? key,
      required this.url,
      required this.uid,
      required this.color,
      required this.onReward})
      : super(key: key);

  @override
  State<WebWidget> createState() => _WebViewState();
}

class _WebViewState extends State<WebWidget> {
  String? clickId;

  late bool isColorBright;
  late WebViewController controller;

  double reward = 0.0;
  String errorId = '';
  bool isPageOfferWall = false;

  @override
  void initState() {
    super.initState();

    isColorBright = widget.color.first.computeLuminance() > 0.729 ||
        widget.color.last.computeLuminance() > 0.729;

    controller = WebViewController()
      ..setNavigationDelegate(NavigationDelegate(
          onWebResourceError: (error) {
            final errorID = '{ uid: ${widget.uid},'
                ' date: ${DateTime.now().millisecondsSinceEpoch},'
                ' url: ${error.url} }';
            setState(() {
              errorId = 'Error ID:\n${base64Encode(errorID.codeUnits)}';
            });
          },
          onPageStarted: onPageStarted,
          onNavigationRequest: (request) {
            final url = request.url;

            if (url.contains('/offers/')) {
              launchUrlString(url, mode: LaunchMode.externalApplication);
              controller.loadRequest(Uri.parse(widget.url));
              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          }))
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (!isPageOfferWall) {
          await showDialog(context: context, builder: showLeaveSurveyDialog);
        }
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          appBar: isPageOfferWall
              ? null
              : AppBar(
                  flexibleSpace: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: widget.color,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                  iconTheme: IconThemeData(
                    color: isColorBright ? Colors.black : Colors.white,
                  ),
                ),
          body: Stack(fit: StackFit.expand, children: [
            WebViewWidget(controller: controller),
            if (isPageOfferWall)
              Align(
                alignment: const Alignment(1, -0.99),
                child: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(
                    Icons.exit_to_app_outlined,
                    color: isColorBright ? Colors.black : Colors.white,
                    size: 24.0,
                  ),
                ),
              ),
            if (errorId.isNotEmpty)
              Center(
                child: FractionallySizedBox(
                  widthFactor: 0.8,
                  child: Row(children: [
                    QrImageView(data: errorId, size: 70),
                    Flexible(
                      child: StyledText(errorId, fontSize: 12),
                    ),
                  ]),
                ),
              )
          ]),
        ),
      ),
    );
  }

  @override
  void dispose() {
    widget.onReward(reward);
    super.dispose();
  }

  void onPageStarted(String url) {
    setState(() {
      isPageOfferWall = url.startsWith('https://web.bitlabs.ai');
    });

    if (url.contains('survey-compete') ||
        url.contains('survey-screenout') ||
        url.contains('start-bonus')) {
      reward += double.parse(Uri.parse(url).queryParameters['val'] ?? '0.0');
    }

    if (!isPageOfferWall) {
      clickId = Uri.parse(url).queryParameters['clk'] ?? clickId;
    }
  }

  Widget showLeaveSurveyDialog(BuildContext context) {
    return SimpleDialog(
      title: Text(Localization.of(context).leaveDescription),
      children: [
        ...leaveReasonOptions(leaveSurvey: leaveSurvey, context: context),
        SimpleDialogOption(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(Localization.of(context).continueSurvey),
        ),
      ],
    );
  }

  void leaveSurvey(String reason) {
    controller.loadRequest(Uri.parse(widget.url));

    if (clickId == null) return;

    log('[BitLabs] Leaving with reason ~> $reason');
    BitLabs.instance.leaveSurvey(clickId!, reason);
    clickId = null;
  }
}
