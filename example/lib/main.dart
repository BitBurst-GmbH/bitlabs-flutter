import 'dart:developer';

import 'package:bitlabs/bitlabs.dart';
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
        child: SizedBox(
          width: 200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
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
      ),
    );
  }

  void checkForSurveys() {
    BitLabs.instance.checkSurveys((hasSurveys) {
      if (hasSurveys == null) {
        log('[Example] CheckSurveys Error. Check BitLabs logs.');
        return;
      }
      log('[Example] Checking Surveys -> '
          '${hasSurveys ? 'Surveys Available!' : 'No Surveys!'}');
    });
  }

  void getSurveys() {
    BitLabs.instance.getSurveys((surveys) {
      if (surveys == null) {
        log('[Example] GetSurveys Error. Check BitLabs logs.');
        return;
      }
      log('[Example] Getting Surveys -> '
          '${surveys.map((survey) => 'Survey ${survey.id} '
              'in ${survey.details.category.name}')}');
    });
  }
}
