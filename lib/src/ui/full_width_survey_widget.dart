import 'package:bitlabs/src/ui/promotion_view.dart';
import 'package:bitlabs/src/ui/reward_view.dart';
import 'package:bitlabs/src/ui/star_rating.dart';
import 'package:bitlabs/src/ui/styled_text.dart';
import 'package:flutter/material.dart';

class FullWidthSurveyWidget extends StatefulWidget {
  final int rating;
  final String reward;
  final String loi;
  final Color color;
  final Widget? image;

  const FullWidthSurveyWidget(
      {Key? key,
      required this.rating,
      required this.reward,
      required this.loi,
      required this.color,
      this.image})
      : super(key: key);

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
                PromotionView(
                  accentColor: color,
                  color: Colors.white,
                  currencyIcon: widget.image,
                ),
                RewardView(
                  size: 16,
                  reward: widget.reward,
                  currencyIcon: widget.image,
                )
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
