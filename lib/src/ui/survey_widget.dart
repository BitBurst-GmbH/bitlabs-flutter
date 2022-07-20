import 'package:bitlabs/src/ui/star_rating.dart';
import 'package:flutter/material.dart';

import '../../bitlabs.dart';

class SurveyWidget extends StatelessWidget {
  final int rating;
  final String reward;
  final String loi;

  const SurveyWidget(
      {Key? key, required this.rating, required this.reward, required this.loi})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => BitLabs.instance.launchOfferWall(context),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.blueAccent,
          borderRadius: BorderRadius.circular(8),
        ),
        width: 300,
        constraints: const BoxConstraints(minWidth: 300, maxHeight: 80),
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(children: [
                  const Icon(
                    Icons.access_time,
                    size: 16,
                    color: Colors.white,
                  ),
                  Text(' $loi', style: const TextStyle(color: Colors.white)),
                ]),
                Row(children: [
                  StarRating(rating: rating),
                  Text(' $rating', style: const TextStyle(color: Colors.white)),
                ]),
              ],
            ),
            Container(
              height: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8),
                    child: Icon(Icons.play_circle_outlined, size: 32),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      'EARN\n$reward',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
