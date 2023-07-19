import 'package:bitlabs/src/ui/reward_view.dart';
import 'package:flutter/material.dart';

import 'styled_text.dart';

class PromotionView extends StatelessWidget {
  final String reward;
  final List<Color> color;
  final Color accentColor;
  final int bonusPercentage;
  final Widget? currencyIcon;

  const PromotionView({
    Key? key,
    this.currencyIcon,
    required this.color,
    required this.reward,
    required this.accentColor,
    required this.bonusPercentage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        RewardView(
          size: 12,
          fontSize: 11,
          reward: reward,
          color: color.first,
          currencyIcon: currencyIcon,
          decoration: TextDecoration.lineThrough,
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: color,
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
            ),
            borderRadius: BorderRadius.circular(5),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 3),
          child: StyledText(
            '+$bonusPercentage%',
            fontSize: 11,
            color: accentColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
