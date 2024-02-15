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

  bool isLeaderboardVisible = false;

  @override
  void initState() {
    super.initState();
    BitLabs.instance.init(appToken, 'oblivatevariegata');

    BitLabs.instance.setOnReward(
        (reward) => log('[Example] Reward for this session: $reward'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: ColoredBox(
        color: Colors.redAccent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: [
            if (isLeaderboardVisible)
              const ColoredBox(
                  color: Colors.purpleAccent, child: BitLabsLeaderboard()),
            ColoredBox(
              color: Colors.greenAccent,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      const SizedBox(width: 4),
                      Expanded(
                        child: CustomButton(
                          onPressed: () =>
                              setState(() => isLeaderboardVisible = true),
                          title: 'Show Leaderboard',
                        ),
                      ),
                      const SizedBox(width: 4),
                    ],
                  ),
                  Row(
                    children: [
                      const SizedBox(width: 4),
                      Expanded(
                        child: CustomButton(
                          onPressed:
                              BitLabs.instance.requestTrackingAuthorization,
                          title: 'Authorize Tracking(iOS)',
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: CustomButton(
                          onPressed: checkForSurveys,
                          title: 'Check for Surveys',
                        ),
                      ),
                      const SizedBox(width: 4),
                    ],
                  ),
                  Row(
                    children: [
                      const SizedBox(width: 4),
                      Expanded(
                        child: CustomButton(
                          onPressed: () =>
                              BitLabs.instance.launchOfferWall(context),
                          title: 'Open OfferWall',
                        ),
                      ),
                      const SizedBox(width: 4),
                    ],
                  ),
                  Row(
                    children: [
                      const SizedBox(width: 4),
                      Expanded(
                        child: CustomButton(
                          onPressed: getSurveys,
                          title: 'Get Surveys',
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: CustomButton(
                          title: 'Show Survey Widget',
                        ),
                      ),
                      const SizedBox(width: 4),
                    ],
                  ),
                ],
              ),
            ),
            ColoredBox(
                color: Colors.cyan,
                child: SizedBox(
                    height: 150, child: surveyWidgets ?? const SizedBox())),
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
      (surveys) => setState(() {
            surveyWidgets = ListView(
                scrollDirection: Axis.horizontal,
                children: BitLabs.instance
                    .getSurveyWidgets(surveys, WidgetType.simple));
          }),
      (exception) => log('[Example] GetSurveys $exception'));
}

class CustomButton extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;

  const CustomButton({Key? key, required this.title, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: onPressed, child: Text(title));
  }
}
