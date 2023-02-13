import 'package:bitlabs/bitlabs.dart';
import 'package:bitlabs/src/ui/simple_survey_widget.dart';
import 'package:flutter/widgets.dart';

import '../models/widget_type.dart';
import 'full_width_survey_widget.dart';

class SurveyWidget extends StatefulWidget {
  final String loi;
  final int rating;
  final Color color;
  final String reward;
  final WidgetType type;

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
  late Color color;

  @override
  void initState() {
    super.initState();
    color = widget.color;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        // Start onTap Animation
        setState(() => color = widget.color.withAlpha(100));
        await Future.delayed(const Duration(milliseconds: 50));
        setState(() => color = widget.color.withAlpha(255));
        await Future.delayed(const Duration(milliseconds: 40));
        // End onTap Animation

        if (!mounted) return;
        BitLabs.instance.launchOfferWall(context);
      },
      child: AnimatedContainer(
        curve: Curves.fastOutSlowIn,
        duration: const Duration(milliseconds: 50),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(5),
        ),
        height: 100,
        width: MediaQuery.of(context).size.width * 0.96,
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: getWidgetWithType(
          widget.type,
          widget.rating,
          widget.reward,
          widget.loi,
          color,
        ),
      ),
    );
  }
}

Widget getWidgetWithType(
    WidgetType type, int rating, String reward, String loi, Color color) {
  switch (type) {
    case WidgetType.simple:
      return SimpleSurveyWidget(reward: reward, loi: loi);
    case WidgetType.fullWidth:
      return FullWidthSurveyWidget(
          rating: rating, reward: reward, loi: loi, color: color);
    case WidgetType.compact:
      return CompactSurveyWidget(
          rating: rating, reward: reward, loi: loi, color: color);
  }
}
