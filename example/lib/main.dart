import 'dart:developer';

import 'package:bitlabs/bitlabs.dart';
import 'package:example/secrets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        ...GlobalMaterialLocalizations.delegates,
        LocalizationDelegate(),
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('es', ''),
        Locale('de', ''),
        Locale('fr', ''),
        Locale('it', ''),
      ],
      home: const HomePage(title: 'BitLabs Example'),
    );
  }
}

class HomePage extends StatefulWidget {
  final String title;

  const HomePage({Key? key, required this.title}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ListView? surveyWidgets;
  final uid = 'oblivatevariegata';

  bool isLeaderboardVisible = false;
  bool isSurveyWidgetVisible = false;

  @override
  void initState() {
    super.initState();
    BitLabs.instance.init(appToken, uid);

    BitLabs.instance.setOnReward(
      (reward) => log('[Example] Reward for this session: $reward'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: Column(
          spacing: 4,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              spacing: 8,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => BitLabs.instance.openMagicReceiptsMerchant('7'),
                    child: const Text('Open Shopping Merchant: 7'),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => BitLabs.instance.openMagicReceiptsOffer('311768'),
                    child: const Text('Open Shopping Offer: 311768'),
                  ),
                ),
              ],
            ),
            Row(
              spacing: 8,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: BitLabs.instance.requestTrackingAuthorization,
                    child: const Text('Authorize Tracking(iOS)'),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => BitLabs.instance.openOffer('1671485'),
                    child: const Text('Open Shopping Offer:Open Offer with id: 1671485'),
                  ),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () => BitLabs.instance.launchOfferWall(context),
              child: const Text('Open OfferWall'),
            ),
            Row(
              spacing: 8,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: getSurveys,
                    child: const Text('Get Surveys'),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: checkForSurveys,
                    child: const Text('Check for Surveys'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void checkForSurveys() => BitLabs.instance.checkSurveys(
      (hasSurveys) => log('[Example] Checking Surveys -> '
          '${hasSurveys ? 'Surveys Available!' : 'No Surveys!'}'),
      (exception) => log('[Example] CheckSurveys $exception'));

  void getSurveys() => BitLabs.instance.getSurveys(
        (surveys) {
          for (final element in surveys) {
            log('[Example] Survey: ${element.id} - ${element.value} - ${element.rating}');
          }
        },
        (exception) => log('[Example] GetSurveys $exception'),
      );
}
