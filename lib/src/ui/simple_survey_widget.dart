import 'package:bitlabs/src/ui/promotion_view.dart';
import 'package:bitlabs/src/ui/styled_text.dart';
import 'package:flutter/material.dart';

class SimpleSurveyWidget extends StatefulWidget {
  final String reward;
  final Color color;
  final String loi;

  const SimpleSurveyWidget({
    Key? key,
    required this.reward,
    required this.color,
    required this.loi,
  }) : super(key: key);

  @override
  State<SimpleSurveyWidget> createState() => _SimpleSurveyWidgetState();
}

class _SimpleSurveyWidgetState extends State<SimpleSurveyWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const Icon(
          Icons.play_circle_outline,
          size: 62,
          color: Colors.white,
        ),
        IntrinsicWidth(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              PromotionView(
                color: Colors.white,
                accentColor: widget.color,
              ),
              StyledText(
                'EARN ${widget.reward}',
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              StyledText(
                'Now in ${widget.loi}!',
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
