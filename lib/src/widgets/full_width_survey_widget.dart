import 'package:bitlabs/src/widgets/promotion_view.dart';
import 'package:bitlabs/src/widgets/reward_view.dart';
import 'package:bitlabs/src/widgets/star_rating.dart';
import 'package:bitlabs/src/widgets/styled_text.dart';
import 'package:flutter/material.dart';

class FullWidthSurveyWidget extends StatefulWidget {
  final int rating;
  final String loi;
  final Color color;
  final String reward;
  final Widget? image;
  final String oldReward;
  final int bonusPercentage;

  const FullWidthSurveyWidget({
    super.key,
    this.image,
    required this.loi,
    required this.color,
    required this.rating,
    required this.reward,
    required this.oldReward,
    required this.bonusPercentage,
  });

  @override
  State<FullWidthSurveyWidget> createState() => _FullWidthSurveyWidgetState();
}

class _FullWidthSurveyWidgetState extends State<FullWidthSurveyWidget> {
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
        Row(children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(children: [
              StarRating(rating: widget.rating),
              StyledText(' ${widget.rating}', color: Colors.white)
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
                child: StyledText(widget.loi, color: Colors.white),
              ),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.bonusPercentage > 0)
                  PromotionView(
                    accentColor: color,
                    reward: widget.oldReward,
                    currencyIcon: widget.image,
                    bonusPercentage: widget.bonusPercentage,
                    color: const [Colors.white, Colors.white],
                  ),
                RewardView(
                  size: 16,
                  reward: widget.reward,
                  currencyIcon: widget.image,
                ),
              ],
            ),
          ),
        ]),
        TextButton(
          style: OutlinedButton.styleFrom(
              backgroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16)),
          onPressed: null,
          child: StyledText('EARN NOW', color: color),
        ),
      ],
    );
  }
}
