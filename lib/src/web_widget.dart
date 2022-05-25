import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../bitlabs.dart';
import 'utilities/helpers.dart';
import 'utilities/localization.dart';

class WebWidget extends StatefulWidget {
  final String url;
  final void Function(double) onReward;

  const WebWidget({Key? key, required this.url, required this.onReward})
      : super(key: key);

  @override
  State<WebWidget> createState() => _WebViewState();
}

class _WebViewState extends State<WebWidget> {
  String? _surveyId;
  String? _networkId;
  WebViewController? _controller;

  double _reward = 0.0;
  bool _isPageOfferWall = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (!_isPageOfferWall) {
          await showDialog(context: context, builder: showLeaveSurveyDialog);
        }
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          appBar: _isPageOfferWall ? null : AppBar(),
          body: Stack(fit: StackFit.expand, children: [
            WebView(
              initialUrl: widget.url,
              onPageStarted: _onPageStarted,
              navigationDelegate: (request) {
                if (request.url.startsWith('https://api.bitlabs.ai')) {
                  _extractNetworkAndSurveyIds(request.url);
                }

                return NavigationDecision.navigate;
              },
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (controller) => (_controller = controller),
            ),
            !_isPageOfferWall
                ? const SizedBox.shrink()
                : Align(
                    alignment: const Alignment(1, -0.99),
                    child: IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(
                        Icons.close,
                        color: Colors.black,
                        size: 24.0,
                      ),
                    ),
                  ),
          ]),
        ),
      ),
    );
  }

  @override
  void dispose() {
    widget.onReward(_reward);
    super.dispose();
  }

  void _onPageStarted(String url) {
    setState(() {
      _isPageOfferWall = url.startsWith('https://web.bitlabs.ai');
    });

    if (url.contains('survey/compete') || url.contains('survey/screenout')) {
      _reward += double.parse(Uri.parse(url).queryParameters['val'] ?? '0.0');
    }

    if (!_isPageOfferWall) _extractNetworkAndSurveyIds(url);
  }

  Widget showLeaveSurveyDialog(BuildContext context) {
    return SimpleDialog(
      title: Text(Localization.of(context).leaveDescription),
      children: [
        ...leaveReasonOptions(leaveSurvey: _leaveSurvey, context: context),
        SimpleDialogOption(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(Localization.of(context).continueSurvey),
        ),
      ],
    );
  }

  void _leaveSurvey(String reason) {
    _controller?.loadUrl(widget.url);

    if (_networkId == null || _surveyId == null) return;

    log('Leaving with reason ~> $reason');
    BitLabs.instance.leaveSurvey(_networkId!, _surveyId!, reason);
    _networkId = null;
    _surveyId = null;
  }

  void _extractNetworkAndSurveyIds(String url) {
    if (_networkId != null && _surveyId != null) return;

    final segments = Uri.parse(url).pathSegments;
    if (!segments.contains('networks') || !segments.contains('surveys')) {
      return;
    }

    _networkId = segments[segments.indexOf('networks') + 1];
    _surveyId = segments[segments.indexOf('surveys') + 1];
  }
}
