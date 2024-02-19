import 'package:bitlabs/src/widgets/promotion_view.dart';
import 'package:bitlabs/src/widgets/styled_text.dart';
import 'package:flutter/material.dart';

import 'reward_view.dart';

class SimpleSurveyWidget extends StatefulWidget {
  final String loi;
  final Color color;
  final String reward;
  final Widget? image;
  final String oldReward;
  final int bonusPercentage;

  const SimpleSurveyWidget({
    Key? key,
    this.image,
    required this.loi,
    required this.color,
    required this.reward,
    required this.oldReward,
    required this.bonusPercentage,
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
              if (widget.bonusPercentage > 0)
                PromotionView(
                  reward: widget.oldReward,
                  accentColor: widget.color,
                  currencyIcon: widget.image,
                  color: const [Colors.white, Colors.white],
                  bonusPercentage: widget.bonusPercentage,
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
