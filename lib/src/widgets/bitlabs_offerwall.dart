import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:bitlabs/src/utils/hook_message_helper.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

import '../../bitlabs.dart';
import '../utils/helpers.dart';
import '../utils/localization.dart';
import 'styled_text.dart';

const String BASE_URL = 'https://web.bitlabs.ai';
const String ADGATE_SUPPORT_URL = 'https://wall.adgaterewards.com/contact/';
const String POST_MESSAGE_SCRIPT = '''
  if (!window.isEventListenerAdded) {
    window.addEventListener('message', function(event) {
      window.FlutterWebView.postMessage(JSON.stringify(event.data));
    });
    window.isEventListenerAdded = true;
  }
''';

/// Launches the Offer Wall in a [WebView].
class BitLabsOfferwall extends StatefulWidget {
  final String uid;
  final String adId;
  final String token;
  final bool debugMode;
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
    this.debugMode = false,
    this.color = const [Colors.blueAccent, Colors.blueAccent],
  }) : super(key: key);

  @override
  State<BitLabsOfferwall> createState() => OfferwallState();
}

@visibleForTesting
class OfferwallState extends State<BitLabsOfferwall> {
  String? clickId;

  late bool isColorBright;
  late final String initialUrl;
  late WebViewController controller;

  double reward = 0.0;
  String errorId = '';
  bool isPageOfferWall = false;
  bool isPageAdGateSupport = false;

  @override
  void initState() {
    super.initState();

    initialUrl =
        offerWallUrl(widget.token, widget.uid, widget.adId, widget.tags);

    isColorBright = widget.color.first.computeLuminance() > 0.729 ||
        widget.color.last.computeLuminance() > 0.729;


    initializeWebView();

    if (Platform.isAndroid) {
      // or: if (webViewController.platform is AndroidWebViewController)
      final myAndroidController =
          controller.platform as AndroidWebViewController;

      myAndroidController.setOnShowFileSelector((params) async {
        log('[BitLabs] File selector params: ${params..acceptTypes}');

        final imageSource = await chooseImageSource();
        if (imageSource == null) return [];

        final picker = ImagePicker();
        final photo = await picker.pickImage(source: imageSource);

        if (photo == null) return [];

        return [Uri.file(photo.path).toString()];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (isPageOfferWall) return;

        if (isPageAdGateSupport) {
          controller.loadRequest(Uri.parse(initialUrl));
          return;
        }

        await showDialog(context: context, builder: showLeaveSurveyDialog);
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

  void initializeWebView() async {
    controller = WebViewController(
      onPermissionRequest: (request) => request.grant(),
    )
      ..setNavigationDelegate(NavigationDelegate(
          onWebResourceError: onWebResourceError,
          onUrlChange: onUrlChanged,
          onPageFinished: (_) => controller.runJavaScript(POST_MESSAGE_SCRIPT),
          onNavigationRequest: (request) {
            final url = request.url;

            if (url.contains('/offers/')) {
              launchUrlString(url, mode: LaunchMode.externalApplication);
              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          }))
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'FlutterWebView',
        onMessageReceived: onJavaScriptMessage,
      );

    await controller.loadRequest(Uri.parse(initialUrl));
  }

  void onWebResourceError(WebResourceError error) {
    if (!widget.debugMode) {
      return;
    }

    final errorID = '{ uid: ${widget.uid},'
        ' date: ${DateTime.now().millisecondsSinceEpoch},'
        ' url: ${error.url}, '
        ' type: ${error.errorType},'
        ' description: ${error.description} }';

    setState(() {
      errorId = 'Error ID:\n${base64Encode(errorID.codeUnits)}';
    });
  }

  void onJavaScriptMessage(JavaScriptMessage message) {
    final hookMessage = message.message.toHookMessage();
    if (hookMessage == null) return;

    switch (hookMessage.name) {
      case HookName.surveyComplete:
      case HookName.surveyScreenout:
      case HookName.surveyStartBonus:
        final rewardArg = hookMessage.args.first as RewardArgument;
        setState(() {
          reward += rewardArg.reward;
        });
        break;
      case HookName.surveyStart:
        setState(() {
          clickId = (hookMessage.args.first as SurveyStartArgument).clickId;
        });
        break;
      case HookName.sdkClose:
        Navigator.of(context).pop();
        break;
      case HookName.init:
        controller.runJavaScript('''
        window.parent.postMessage({ target: 'app.behaviour.close_button_visible', value: true }, '*');
      ''');
        break;
      default:
        break;
    }
  }

  void onUrlChanged(UrlChange urlChange) {
    final url = urlChange.url ?? '';

    setState(() => isPageOfferWall = url.startsWith(BASE_URL));
    isPageAdGateSupport = false;

    if (!isPageOfferWall) {
      isPageAdGateSupport = url.startsWith(ADGATE_SUPPORT_URL);
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
    controller.loadRequest(Uri.parse(initialUrl));

    if (clickId == null) return;

    log('[BitLabs] Leaving with reason ~> $reason');
    BitLabs.instance.leaveSurvey(clickId!, reason);
    clickId = null;
  }

  Future<ImageSource?> chooseImageSource() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: Text(Localization.of(context).gallery),
              onTap: () => Navigator.of(context).pop(ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: Text(Localization.of(context).camera),
              onTap: () => Navigator.of(context).pop(ImageSource.camera),
            ),
          ],
        );
      },
    );

    return source;
  }
}
