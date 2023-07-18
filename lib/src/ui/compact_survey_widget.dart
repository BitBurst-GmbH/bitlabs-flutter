import 'package:bitlabs/src/ui/promotion_view.dart';
import 'package:bitlabs/src/ui/reward_view.dart';
import 'package:bitlabs/src/ui/star_rating.dart';
import 'package:bitlabs/src/ui/styled_text.dart';
import 'package:flutter/material.dart';

class CompactSurveyWidget extends StatefulWidget {
  final int rating;
  final String loi;
  final String reward;
  final Widget? image;
  final String oldReward;
  final List<Color> color;
  final int bonusPercentage;

  const CompactSurveyWidget({
    Key? key,
    this.image,
    required this.loi,
    required this.color,
    required this.rating,
    required this.reward,
    required this.oldReward,
    required this.bonusPercentage,
  }) : super(key: key);

  @override
  State<CompactSurveyWidget> createState() => _CompactSurveyWidgetState();
}

class _CompactSurveyWidgetState extends State<CompactSurveyWidget> {
  late List<Color> color;

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
                      color: color.first,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        StyledText(
                          'EARN',
                          fontSize: 16,
                          color: color.first,
                          fontWeight: FontWeight.bold,
                        ),
                        RewardView(
                          size: 16,
                          fontSize: 16,
                          color: color.first,
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
                reward: widget.oldReward,
                accentColor: Colors.white,
                currencyIcon: widget.image,
                bonusPercentage: widget.bonusPercentage,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
