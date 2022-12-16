
import 'package:bitlabs/bitlabs.dart';
import 'package:bitlabs/src/ui/simple_survey_widget.dart';
import 'package:flutter/widgets.dart';

import '../models/widget_type.dart';

class SurveyWidget extends StatefulWidget {
  final String loi;
  final int rating;
  final Color color;
  final String reward;

  const SurveyWidget({Key? key, required this.reward, required this.loi, required this.color, required this.rating})
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
      },
      child: getWidgetWithType(WidgetType.simple, widget.rating, widget.reward, widget.loi, color),
    );
  }
}

Widget getWidgetWithType(WidgetType type, int rating, String reward, String loi, Color color) {
  switch (type) {
    case WidgetType.simple: return SimpleSurveyWidget(reward: reward, loi: loi, color: color);
    case WidgetType.compact:
    default:
      return CompactSurveyWidget(rating: rating, reward: reward, loi: loi, color: color);
  }
}
