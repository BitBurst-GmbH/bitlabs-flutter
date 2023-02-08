import 'package:bitlabs/src/ui/star_rating.dart';
import 'package:flutter/material.dart';

class FullWidthSurveyWidget extends StatefulWidget {
  final int rating;
  final String reward;
  final String loi;

  const FullWidthSurveyWidget(
      {Key? key, required this.rating, required this.reward, required this.loi})
      : super(key: key);

  @override
  State<FullWidthSurveyWidget> createState() => _FullWidthSurveyWidgetState();
}

class _FullWidthSurveyWidgetState extends State<FullWidthSurveyWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.blueAccent,
      ),
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Row(children: [
                StarRating(rating: widget.rating),
                Text(
                  ' ${widget.rating}',
                  style: const TextStyle(color: Colors.white),
                ),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Row(children: [
                const Icon(
                  Icons.access_time,
                  size: 16,
                  color: Colors.white,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    '${widget.loi} minutes',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                widget.reward,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ]),
          TextButton(
            style: OutlinedButton.styleFrom(
                backgroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16)),
            onPressed: () {},
            child: const Text('EARN NOW'),
          ),
        ],
      ),
    );
  }
}
