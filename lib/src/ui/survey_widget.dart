import 'package:bitlabs/src/ui/star_rating.dart';
import 'package:flutter/material.dart';

class SurveyWidget extends StatelessWidget {
  const SurveyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
              Row(children: const [
                Icon(
                  Icons.access_time,
                  size: 16,
                  color: Colors.white,
                ),
                Text(' 1 minute', style: TextStyle(color: Colors.white)),
              ]),
              Row(children: const [
                StarRating(rating: 1.5),
                Text(' 5', style: TextStyle(color: Colors.white)),
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
              children: const [
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Icon(Icons.play_circle_outlined, size: 32),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Text('EARN\n0.50', style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
