import 'package:flutter/material.dart';

class StarRating extends StatelessWidget {
  final int rating;

  const StarRating({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(5, (index) => buildStar(context, index)),
    );
  }

  buildStar(BuildContext context, int index) => index >= rating
      ? const Icon(Icons.star_border_rounded, color: Colors.white, size: 16)
      : const Icon(Icons.star_rounded, color: Colors.white, size: 16);
}
