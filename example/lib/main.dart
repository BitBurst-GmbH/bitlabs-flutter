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
        (reward) => log('[Example] Reward for this session: $reward'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const SizedBox(height: 8),
          Expanded(
            flex: 5,
            child: isLeaderboardVisible
                ? BitLabsWidget(
                    token: appToken,
                    uid: uid,
                    type: WidgetType.leaderboard,
                  )
                : const SizedBox.shrink(),
          ),
          Column(
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
                      onPressed: BitLabs.instance.requestTrackingAuthorization,
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
                  Expanded(
                    child: CustomButton(
                      onPressed: () =>
                          setState(() => isSurveyWidgetVisible = true),
                      title: 'Show Survey Widget',
                    ),
                  ),
                  const SizedBox(width: 4),
                ],
              ),
            ],
          ),
          if (isSurveyWidgetVisible)
            BitLabsWidget(
              token: appToken,
              uid: uid,
              type: WidgetType.simple,
            ),
          const Spacer(),
        ],
      ),
    );
  }

  void checkForSurveys() => BitLabs.instance.checkSurveys(
      (hasSurveys) => log('[Example] Checking Surveys -> '
          '${hasSurveys ? 'Surveys Available!' : 'No Surveys!'}'),
      (exception) => log('[Example] CheckSurveys $exception'));

  void getSurveys() => BitLabs.instance.getSurveys(
      (surveys) => surveys.forEach((element) => log(
          '[Example] Survey: ${element.id} - ${element.value} - ${element.rating}')),
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
