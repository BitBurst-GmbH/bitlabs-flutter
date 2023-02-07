import 'package:flutter/material.dart';

import '../../bitlabs.dart';

class SimpleSurveyWidget extends StatefulWidget {
  final String reward;
  final String loi;
  final Color color;

  const SimpleSurveyWidget(
      {Key? key, required this.reward, required this.loi, required this.color})
      : super(key: key);

  @override
  State<SimpleSurveyWidget> createState() => _SimpleSurveyWidgetState();
}

class _SimpleSurveyWidgetState extends State<SimpleSurveyWidget> {
  late Color color;

  @override
  void initState() {
    super.initState();
    color = widget.color;
  }

  @override
  Widget build(BuildContext context) {
    return  Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Icon(
              Icons.play_circle_outline,
              size: 62,
              color: Colors.white,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'EARN ${widget.reward}',
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Now in ${widget.loi}!',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        );
  }
}
