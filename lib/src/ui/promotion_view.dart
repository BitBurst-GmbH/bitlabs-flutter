import 'package:flutter/material.dart';

import 'styled_text.dart';

class PromotionView extends StatelessWidget {
  final Color color;
  final Color accentColor;

  const PromotionView(
      {Key? key, required this.color, required this.accentColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        StyledText(
          '0.05',
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.lineThrough,
        ),
        Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(5),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 3),
          child: StyledText(
            '+20%',
            color: accentColor,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
