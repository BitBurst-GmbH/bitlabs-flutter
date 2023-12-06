import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../bitlabs.dart';
import '../utils/helpers.dart';
import '../utils/localization.dart';
import 'styled_text.dart';

/// Launches the Offer Wall in a [WebView].
class BitLabsOfferwall extends StatefulWidget {
  final String uid;
  final String adId;
  final String token;
  final List<Color> color;
  final Map<String, dynamic> tags;
  final void Function(double)? onReward;

  const BitLabsOfferwall({
    Key? key,
    this.onReward,
    this.adId = '',
    required this.uid,
    required this.token,
    this.tags = const {},
    this.color = const [Colors.blueAccent, Colors.blueAccent],
  }) : super(key: key);

  @override
  State<BitLabsOfferwall> createState() => OfferwallState();
}

@visibleForTesting
class OfferwallState extends State<BitLabsOfferwall> {
  String? clickId;

  late final String url;
  late bool isColorBright;
  late WebViewController controller;

  double reward = 0.0;
  String errorId = '';
  bool isPageOfferWall = false;
  bool areParametersInjected = true;

  @override
  void initState() {
    super.initState();

    url = offerWallUrl(widget.token, widget.uid, widget.adId, widget.tags);

    isColorBright = widget.color.first.computeLuminance() > 0.729 ||
        widget.color.last.computeLuminance() > 0.729;

    controller = WebViewController()
      ..setNavigationDelegate(NavigationDelegate(
          onWebResourceError: (error) {
            if (error.errorType == WebResourceErrorType.hostLookup) return;

            final errorID = '{ uid: ${widget.uid},'
                ' date: ${DateTime.now().millisecondsSinceEpoch},'
                ' url: ${error.url}, '
                ' type: ${error.errorType},'
                ' description: ${error.description} }';

            setState(() {
              errorId = 'Error ID:\n${base64Encode(errorID.codeUnits)}';
            });
          },
          onUrlChange: onUrlChanged,
          onNavigationRequest: (request) {
            final url = request.url;

            if (url.contains('/offers/')) {
              launchUrlString(url, mode: LaunchMode.externalApplication);
              controller.loadRequest(Uri.parse(url));
              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          }))
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(url));
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
    widget.onReward?.call(reward);
    super.dispose();
  }

  void onUrlChanged(UrlChange urlChange) {
    final url = urlChange.url ?? '';

    if (url.endsWith('/close')) {
      Navigator.of(context).pop();
      return;
    }

    setState(() => isPageOfferWall = url.startsWith('https://web.bitlabs.ai'));

    if (url.contains('survey-compete') ||
        url.contains('survey-screenout') ||
        url.contains('start-bonus')) {
      reward += double.parse(Uri.parse(url).queryParameters['val'] ?? '0.0');

      if (!areParametersInjected && !url.contains('sdk=FLUTTER')) {
        areParametersInjected = true;
        var newUrl =
            '$url&sdk=FLUTTER&os=${Platform.isIOS ? 'ios' : 'android'}&uid=${widget.uid}&token=${widget.token}';
        if (widget.adId.isNotEmpty) newUrl += '&maid=${widget.adId}';

        if (widget.tags.isNotEmpty) {
          widget.tags.forEach((key, value) {
            newUrl += '&$key=$value';
          });
        }

        controller.loadRequest(Uri.parse(newUrl));
      }
    }

    if (!isPageOfferWall) {
      clickId = Uri.parse(url).queryParameters['clk'] ?? clickId;
      areParametersInjected = false;
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
    setState(() => errorId = '');
    controller.loadRequest(Uri.parse(url));

    if (clickId == null) return;

    log('[BitLabs] Leaving with reason ~> $reason');
    BitLabs.instance.leaveSurvey(clickId!, reason);
    clickId = null;
  }
}
