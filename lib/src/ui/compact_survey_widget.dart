import 'package:bitlabs/src/ui/star_rating.dart';
import 'package:flutter/material.dart';

import '../../bitlabs.dart';

class CompactSurveyWidget extends StatefulWidget {
  final int rating;
  final String reward;
  final String loi;
  final Color color;

  const CompactSurveyWidget(
      {Key? key,
      required this.rating,
      required this.reward,
      required this.loi,
      required this.color})
      : super(key: key);

  @override
  State<CompactSurveyWidget> createState() => _CompactSurveyWidgetState();
}

class _CompactSurveyWidgetState extends State<CompactSurveyWidget> {
  late Color color;

  @override
  void initState() {
    super.initState();
    color = widget.color;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        // Start onTap Animation
        setState(() => color = widget.color.withAlpha(100));
        await Future.delayed(const Duration(milliseconds: 50));
        setState(() => color = widget.color.withAlpha(255));
        await Future.delayed(const Duration(milliseconds: 40));
        // End onTap Animation

        if (!mounted) return;
        BitLabs.instance.launchOfferWall(context);
      },
      child: AnimatedContainer(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(5),
        ),
        width: 300,
        constraints: const BoxConstraints(minWidth: 300, maxHeight: 80),
        padding: const EdgeInsets.all(8),
        duration: const Duration(milliseconds: 50),
        curve: Curves.fastOutSlowIn,
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
                  Text(
                    ' ${widget.loi}',
                    style: const TextStyle(color: Colors.white),
                  ),
                ]),
                Row(children: [
                  StarRating(rating: widget.rating),
                  Text(
                    ' ${widget.rating}',
                    style: const TextStyle(color: Colors.white),
                  ),
                ]),
              ],
            ),
            Container(
              height: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8),
                    child: Icon(Icons.play_circle_outline_outlined, size: 38),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
                    child: Text(
                      'EARN\n${widget.reward}',
                      style: TextStyle(
                        color: color,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
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
