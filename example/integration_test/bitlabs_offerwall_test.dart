import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:bitlabs/bitlabs.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:example/secrets.dart'; // Ensure `appToken` is defined in secrets.dart

void main() {
  const validUid = 'randomUID';
  const token = appToken;

  testWidgets('Given valid UID and token, then displays offerwall',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: BitLabsOfferwall(uid: validUid, token: token),
      ),
    );

    expect(find.byType(BitLabsOfferwall), findsOneWidget);
    expect(find.byType(WebViewWidget), findsOneWidget);

    await tester.pumpAndSettle();
  });

  testWidgets(
      'Given back press when shouldShowAppBar true, then displays leave survey dialog',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: BitLabsOfferwall(uid: 'testUID', token: 'testToken'),
      ),
    );

    final state = tester.state<OfferwallState>(find.byType(BitLabsOfferwall));
    state.shouldShowAppBar = true;

    // Simulate a back press
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    expect(find.text('Choose a reason for leaving the survey'), findsOneWidget);
  });

  testWidgets('Given error in debug mode, then displays QR code',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: BitLabsOfferwall(
          uid: 'testUID',
          token: 'testToken',
          debugMode: true,
        ),
      ),
    );

    final state = tester.state<OfferwallState>(find.byType(BitLabsOfferwall));
    state.onWebResourceError(
      const WebResourceError(
        errorCode: 404,
        description: 'Not Found',
        errorType: WebResourceErrorType.hostLookup,
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(QrImageView), findsOneWidget);
  });

  testWidgets('Given dispose, then invokes onReward callback', (tester) async {
    double reward = 0.0;

    await tester.pumpWidget(
      MaterialApp(
        home: BitLabsOfferwall(
          uid: 'testUID',
          token: 'testToken',
          onReward: (r) => reward = r,
        ),
      ),
    );

    // Simulate adding a reward
    final state = tester.state<OfferwallState>(find.byType(BitLabsOfferwall));
    state.reward = 30.0;

    // Dispose the widget to trigger the callback
    await tester.pumpWidget(Container());

    expect(reward, 30.0);
  });

  //test the Javascript communication
  testWidgets('Given survey start event message, then shouldShowAppBar is true',
      (tester) async {
    const hookMessage =
        '{"type":"hook","name":"offerwall-surveys:survey.start","args":[{"clickId": "1234", "link": "arbitrary_link"}]}';

    await tester.pumpWidget(
      const MaterialApp(
        home: BitLabsOfferwall(uid: validUid, token: token),
      ),
    );

    await tester.pumpAndSettle();

    final state = tester.state<OfferwallState>(find.byType(BitLabsOfferwall));
    state.onJavaScriptMessage(const JavaScriptMessage(message: hookMessage));

    await tester.pumpAndSettle();

    expect(state.shouldShowAppBar, true);
  });

  testWidgets('Given survey complete event message, then updates reward',
      (tester) async {
    const hookMessage =
        '{"type":"hook","name":"offerwall-surveys:survey.complete","args":[{"reward": 5.0}]}';

    await tester.pumpWidget(
      const MaterialApp(
        home: BitLabsOfferwall(uid: validUid, token: token),
      ),
    );

    await tester.pumpAndSettle();

    final state = tester.state<OfferwallState>(find.byType(BitLabsOfferwall));
    state.onJavaScriptMessage(const JavaScriptMessage(message: hookMessage));

    await tester.pumpAndSettle();

    expect(state.reward, 5.0);
  });
}
