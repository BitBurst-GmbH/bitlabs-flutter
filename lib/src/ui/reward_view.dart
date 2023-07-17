import 'package:flutter/material.dart';

import 'styled_text.dart';

class RewardView extends StatelessWidget {
  final double size;
  final Color color;
  final String reward;
  final double? fontSize;
  final Widget? currencyIcon;
  final TextDecoration? decoration;

  const RewardView({
    Key? key,
    this.fontSize,
    this.decoration,
    this.currencyIcon,
    required this.size,
    required this.reward,
    this.color = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
      StyledText(
        reward,
        color: color,
        fontSize: fontSize,
        decoration: decoration,
        fontWeight: FontWeight.w500,
      ),
      Padding(
        padding: const EdgeInsets.only(left: 2),
        child: currencyIcon != null
            ? SizedBox(width: size, height: size, child: currencyIcon)
            : const SizedBox.shrink(),
      ),
    ]);
  }
}
