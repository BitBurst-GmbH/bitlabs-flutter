import 'dart:developer';

import 'package:bitlabs/bitlabs.dart';
import 'package:bitlabs/utilities.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebWidget extends StatefulWidget {
  final String url;
  final void Function(double) onReward;

  const WebWidget({Key? key, required this.url, required this.onReward})
      : super(key: key);

  @override
  State<WebWidget> createState() => _WebViewState();
}

class _WebViewState extends State<WebWidget> {
  bool isPageOfferWall = false;
  String? networkId;
  String? surveyId;
  double reward = 0.0;

  WebViewController? _controller;

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
          appBar: isPageOfferWall ? null : AppBar(),
          body: Stack(fit: StackFit.expand, children: [
            WebView(
              initialUrl: widget.url,
              onPageStarted: _onPageStarted,
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (controller) => (_controller = controller),
            ),
            !isPageOfferWall
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
    widget.onReward(reward);
    super.dispose();
  }

  void _onPageStarted(String url) {
    setState(() {
      isPageOfferWall = url.startsWith('https://web.bitlabs.ai');
    });

    if (isPageOfferWall) return;

    if (url.contains('survey/compete') || url.contains('survey/screenout')) {
      reward += (Uri.parse(url).queryParameters['val'] as double?) ?? 0.0;
    } else {
      final segments = Uri.parse(url).pathSegments;
      networkId = segments[segments.indexOf('networks') + 1];
      surveyId = segments[segments.indexOf('surveys') + 1];
    }
  }

  Widget showLeaveSurveyDialog(BuildContext context) {
    return SimpleDialog(
      title: const Text('Choose a reason for leaving the survey'),
      children: [
        ...leaveReasonOptions(leaveSurvey: leaveSurvey, context: context),
        SimpleDialogOption(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Continue the survey'),
        ),
      ],
    );
  }

  void leaveSurvey(String reason) {
    _controller?.loadUrl(widget.url);

    if (networkId != null && surveyId != null) {
      log('Leaving with reason ~> $reason');
      BitLabs.instance.leaveSurvey(networkId!, surveyId!, reason);
    }
  }
}
