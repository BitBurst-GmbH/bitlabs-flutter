import 'package:flutter/material.dart';

class StarRating extends StatelessWidget {
  final double rating;

  const StarRating({Key? key, required this.rating}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(5, (index) => buildStar(context, index)),
    );
  }

  buildStar(BuildContext context, int index) {
    Icon icon;
    if (index >= rating) {
      icon = const Icon(
        Icons.star_border_rounded,
        color: Colors.white,
        size: 16,
      );
    } else if (index > rating - 1 && index < rating) {
      icon = const Icon(
        Icons.star_half_rounded,
        color: Colors.white,
        size: 16,
      );
    } else {
      icon = const Icon(
        Icons.star_rounded,
        color: Colors.white,
        size: 16,
      );
    }

    return icon;
  }
}
