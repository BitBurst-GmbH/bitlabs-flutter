import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:bitlabs/bitlabs.dart';
import 'package:example/secrets.dart'; // Ensure `appToken` is defined in secrets.dart

void main() {
  const validUid = 'randomUID';
  const token = appToken;

  testWidgets('Correct UID and Token, Expect Offerwall Stays Open',
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

  testWidgets('URL not Offerwall, Expect isPageOfferWall false',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: BitLabsOfferwall(uid: validUid, token: token),
      ),
    );

    await tester.pumpAndSettle();

    final state = tester.state<OfferwallState>(find.byType(BitLabsOfferwall));
    await state.controller.loadRequest(Uri.parse('https://google.com'));

    await tester.pumpAndSettle();
    expect(state.isPageOfferWall, false);

    await tester.pumpAndSettle();
  });

  testWidgets('URL is Offerwall, Expect isPageOfferWall true', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: BitLabsOfferwall(uid: validUid, token: token),
      ),
    );

    await tester.pumpAndSettle();

    final state = tester.state<OfferwallState>(find.byType(BitLabsOfferwall));
    final initialUrl = state.initialUrl;
    state.controller.loadRequest(Uri.parse(initialUrl));

    await tester.pumpAndSettle();

    expect(state.isPageOfferWall, true);
  });
}
