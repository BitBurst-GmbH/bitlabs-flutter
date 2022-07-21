import 'dart:developer';

import 'package:bitlabs/bitlabs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
      supportedLocales: const [Locale('en', ''), Locale('es', '')],
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

  @override
  void initState() {
    super.initState();
    BitLabs.instance.init('46d31e1e-315a-4b52-b0de-eca6062163af', 'USER_ID');

    BitLabs.instance.setOnReward(
        (reward) => {log('[Example] Reward for this session: $reward')});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 250,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                    onPressed: BitLabs.instance.requestTrackingAuthorization,
                    child: const Text('Authorize Tracking(iOS)'),
                  ),
                  ElevatedButton(
                    onPressed: checkForSurveys,
                    child: const Text('Check for Surveys'),
                  ),
                  ElevatedButton(
                    onPressed: () => BitLabs.instance.launchOfferWall(context),
                    child: const Text('Open OfferWall'),
                  ),
                  ElevatedButton(
                    onPressed: getSurveys,
                    child: const Text('Get Surveys'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 80, child: surveyWidgets ?? const SizedBox()),
          ],
        ),
      ),
    );
  }

  void checkForSurveys() {
    BitLabs.instance.checkSurveys(
        (hasSurveys) => log('[Example] Checking Surveys -> '
            '${hasSurveys ? 'Surveys Available!' : 'No Surveys!'}'),
        (exception) => log('[Example] CheckSurveys $exception'));
  }

  void getSurveys() {
    BitLabs.instance.getSurveys(
        (surveys) => setState(() => surveyWidgets = ListView(
              scrollDirection: Axis.horizontal,
              children: [...BitLabs.instance.getSurveyWidgets(surveys)],
            )),
        (exception) => log('[Example] GetSurveys $exception'));
  }
}
