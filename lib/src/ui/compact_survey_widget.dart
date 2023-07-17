import 'package:bitlabs/src/ui/star_rating.dart';
import 'package:bitlabs/src/ui/styled_text.dart';
import 'package:flutter/material.dart';

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
                        StyledText(
                          widget.reward,
                          color: color,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  StyledText(
                    '0.05',
                    color: color,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.fromLTRB(2, 4, 2, 4),
                    child: const StyledText(
                      '+20%',
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
