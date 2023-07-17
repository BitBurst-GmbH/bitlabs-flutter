import 'package:bitlabs/src/ui/promotion_view.dart';
import 'package:bitlabs/src/ui/reward_view.dart';
import 'package:bitlabs/src/ui/star_rating.dart';
import 'package:bitlabs/src/ui/styled_text.dart';
import 'package:flutter/material.dart';

class CompactSurveyWidget extends StatefulWidget {
  final int rating;
  final String loi;
  final Color color;
  final String reward;
  final Widget? image;

  const CompactSurveyWidget({
    Key? key,
    this.image,
    required this.loi,
    required this.color,
    required this.rating,
    required this.reward,
  }) : super(key: key);

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
    return Row(
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
              StyledText(' ${widget.loi}', color: Colors.white),
            ]),
            Row(children: [
              StarRating(rating: widget.rating),
              StyledText(' ${widget.rating}', color: Colors.white),
            ]),
          ],
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Icon(
                      Icons.play_circle_outline_outlined,
                      size: 38,
                      color: color,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        StyledText(
                          'EARN',
                          color: color,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        RewardView(
                          size: 16,
                          color: color,
                          fontSize: 16,
                          reward: widget.reward,
                          currencyIcon: widget.image,
                        )
                      ],
                    ),
                  ),
                ],
              ),
              PromotionView(
                color: color,
                accentColor: Colors.white,
                currencyIcon: widget.image,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
