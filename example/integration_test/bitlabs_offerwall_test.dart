import 'package:bitlabs/bitlabs.dart';
import 'package:example/secrets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  group('BitLabs Offerwall', () {
    testWidgets('Correct UID and Token, Expect Offerwall Stays Open',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: BitLabsOfferwall(
          uid: 'randomUID',
          token: appToken,
        ),
      ));

      expect(find.byType(BitLabsOfferwall), findsOneWidget);
      expect(find.byType(WebViewWidget), findsOneWidget);
      await tester.pumpAndSettle();
    });

    testWidgets('URL not Offerwall, Expect isPageOfferWall false',
        (tester) async {
      await tester.pumpAndSettle();

      await tester.pumpWidget(const MaterialApp(
        home: BitLabsOfferwall(
          uid: 'randomUID',
          token: appToken,
        ),
      ));

      await tester.pumpAndSettle();

      final state = tester.state<OfferwallState>(find.byType(BitLabsOfferwall));

      state.controller.loadRequest(Uri.parse('https://google.com'));
      await tester.pump();
      await tester.pumpAndSettle();

      await Future.delayed(const Duration(seconds: 5), () async {
        expect(state.isPageOfferWall, false);
      });

      await tester.pumpAndSettle();
    });

    testWidgets('URL is Offerwall, Expect isPageOfferWall true',
        (tester) async {
      await tester.pumpAndSettle();

      await tester.pumpWidget(const MaterialApp(
        home: BitLabsOfferwall(
          uid: 'randomUID',
          token: appToken,
        ),
      ));

      final state = tester.state<OfferwallState>(find.byType(BitLabsOfferwall));

      await tester.pump();
      await tester.pumpAndSettle();

      await Future.delayed(const Duration(seconds: 5), () async {
        expect(state.isPageOfferWall, true);
      });
      await tester.pumpAndSettle();
    });
  });
}
