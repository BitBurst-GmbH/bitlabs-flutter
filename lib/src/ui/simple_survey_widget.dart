import 'package:bitlabs/src/ui/promotion_view.dart';
import 'package:bitlabs/src/ui/styled_text.dart';
import 'package:flutter/material.dart';

import 'reward_view.dart';

class SimpleSurveyWidget extends StatefulWidget {
  final String reward;
  final Color color;
  final String loi;
  final Widget? image;

  const SimpleSurveyWidget({
    Key? key,
    this.image,
    required this.loi,
    required this.color,
    required this.reward,
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
                currencyIcon: widget.image,
              ),
              RewardView(
                reward: 'EARN ${widget.reward}',
                currencyIcon: widget.image,
                color: Colors.white,
                fontSize: 20,
                size: 18,
              ),
              StyledText(
                'Now in ${widget.loi}!',
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 16,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
