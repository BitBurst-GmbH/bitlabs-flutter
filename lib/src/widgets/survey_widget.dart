import 'dart:developer';

import 'package:bitlabs/bitlabs.dart';
import 'package:bitlabs/src/widgets/simple_survey_widget.dart';
import 'package:bitlabs/src/utils/extensions.dart';
import 'package:flutter/widgets.dart';

import '../api/bitlabs_repository.dart';
import '../utils/notifiers.dart' as notifiers;
import 'compact_survey_widget.dart';
import 'full_width_survey_widget.dart';

class SurveyWidget extends StatefulWidget {
  final String loi;
  final int rating;
  final String reward;
  final WidgetType type;
  final List<Color> color;

  const SurveyWidget(
      {Key? key,
      required this.reward,
      required this.loi,
      required this.color,
      required this.rating,
      required this.type})
      : super(key: key);

  @override
  State<SurveyWidget> createState() => _SurveyWidgetState();
}

class _SurveyWidgetState extends State<SurveyWidget> {
  Widget? image;
  var opacity = 1.0;
  double bonusPercentage = 0.0;

  void _updateBonusPercentage() {
    setState(() => bonusPercentage = notifiers.bonusPercentage.value);
  }

  void _updateImageWidget() {
    BitLabsRepository.getCurrencyIcon(
      notifiers.currencyIconURL.value,
      (imageData) => setState(() => image = imageData),
      (e) => log(e.toString()),
    );
  }

  @override
  void initState() {
    super.initState();
    if (notifiers.currencyIconURL.value.isNotEmpty) {
      _updateImageWidget();
    } else {
      notifiers.currencyIconURL.addListener(_updateImageWidget);
    }

    if (notifiers.bonusPercentage.value > 0.0) {
      _updateBonusPercentage();
    } else {
      notifiers.bonusPercentage.addListener(_updateBonusPercentage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        // Start onTap Animation
        setState(() => opacity = .5);
        await Future.delayed(const Duration(milliseconds: 50));
        setState(() => opacity = 1.0);
        await Future.delayed(const Duration(milliseconds: 40));
        // End onTap Animation

        if (!mounted) return;
        BitLabs.instance.launchOfferWall(context);
      },
      child: AnimatedContainer(
        curve: Curves.fastOutSlowIn,
        duration: const Duration(milliseconds: 50),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: widget.color.map((c) => c.withOpacity(opacity)).toList(),
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        width: _getWidgetWidth(widget.type, context),
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: _getWidgetWithType(
          widget.type,
          widget.rating,
          widget.reward,
          (double.parse(widget.reward) / (1 + bonusPercentage)).rounded(),
          widget.loi,
          widget.color,
          image,
          (bonusPercentage * 100).toInt(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    notifiers.currencyIconURL.removeListener(_updateImageWidget);
    notifiers.bonusPercentage.removeListener(_updateBonusPercentage);
    super.dispose();
  }
}

double _getWidgetWidth(WidgetType type, BuildContext context) {
  switch (type) {
    case WidgetType.simple:
      return MediaQuery.of(context).size.width * .7;
    case WidgetType.fullWidth:
      return MediaQuery.of(context).size.width * 1.05;
    case WidgetType.compact:
      return MediaQuery.of(context).size.width * .7;
  }
}

Widget _getWidgetWithType(
    WidgetType type,
    int rating,
    String reward,
    String oldReward,
    String loi,
    List<Color> color,
    Widget? image,
    int bonusPercentage) {
  switch (type) {
    case WidgetType.simple:
      return SimpleSurveyWidget(
        loi: loi,
        color: color.first,
        image: image,
        reward: reward,
        oldReward: oldReward,
        bonusPercentage: bonusPercentage,
      );
    case WidgetType.fullWidth:
      return FullWidthSurveyWidget(
        rating: rating,
        reward: reward,
        loi: loi,
        color: color.first,
        image: image,
        oldReward: oldReward,
        bonusPercentage: bonusPercentage,
      );
    case WidgetType.compact:
      return CompactSurveyWidget(
        rating: rating,
        reward: reward,
        loi: loi,
        color: color,
        image: image,
        oldReward: oldReward,
        bonusPercentage: bonusPercentage,
      );
  }
}
