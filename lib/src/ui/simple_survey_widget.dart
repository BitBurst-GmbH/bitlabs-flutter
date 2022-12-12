import 'package:flutter/material.dart';

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
    return GestureDetector(
      onTap: () async {
        // Start onTap Animation
        setState(() => color = widget.color.withAlpha(100));
        await Future.delayed(const Duration(milliseconds: 50));
        setState(() => color = widget.color.withAlpha(255));
        await Future.delayed(const Duration(milliseconds: 40));
        // End onTap Animation
      },
      child: AnimatedContainer(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(5),
        ),
        width: 300,
        constraints: const BoxConstraints(minWidth: 300),
        padding: const EdgeInsets.all(8),
        duration: const Duration(milliseconds: 50),
        curve: Curves.fastOutSlowIn,
        child: Row(
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
        ),
      ),
    );
  }
}
